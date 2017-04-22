


########################################

#  Matrix Multiplication

#  Idea from https://notes.mindprince.in/2013/06/07/sparse-matrix-multiplication-using-sql.html
# 
#  Lots of details to work on - 
#   1) checking if sizes match


drop table a;
drop table b;
CREATE TABLE a (
row_num INT not null,
col_num INT not null,
value INT,
PRIMARY KEY(row_num, col_num)
);

CREATE TABLE b (
row_num INT not null,
col_num INT not null,
value INT,
PRIMARY KEY(row_num, col_num)
);

CREATE TABLE btrans (
row_num INT not null,
col_num INT not null,
value INT,
PRIMARY KEY(row_num, col_num)
);

    INSERT INTO a VALUES
(1, 2, 1),
(1, 5, 9),
(2, 3, 3),
(3, 4, 2);

INSERT INTO b VALUES
(1, 1, 1),
(3, 2, 7),
(4, 3, 2);


SELECT a.row_num, b.col_num, SUM(a.value*b.value) total
FROM a, b
WHERE a.col_num = b.row_num
GROUP BY a.row_num, b.col_num;

2|2|21
3|3|4


0   1   0   0   9                1   0   0                0   0   0
0   0   3   0   0       \ /      0   0   0      -----     0  21   0
0   0   0   2   0        *       0   7   0      -----     0   0   4
0   0   0   0   0       / \      0   0   2                0   0   0
                                 0   0   0

1 2 5 2 8
5 7 4 5 9
4 6 4 8 5

6 3 2
7 4 8
8 5 3
6 6 2
4 8 7


 INSERT INTO b VALUES
 (1, 1, 6),
 (1, 2, 3),
 (1, 3, 2),
 (2, 1, 7),
 (2, 2, 4),
 (2, 3, 8),
 (3, 1, 8),
 (3, 2, 5),
 (3, 3, 3),
 (4, 1, 6),
 (4, 2, 6),
 (4, 3, 2),
 (5, 1, 4),
 (5, 2, 8),
 (5, 3, 7);

 INSERT INTO a VALUES
  (1, 1, 1),
  (1, 2, 2),
  (1, 3, 5),
  (1, 4, 2),
  (1, 5, 8),
  (2, 1, 5),
  (2, 2, 7),
  (2, 3, 4),
  (2, 4, 5),
  (2, 5, 9),
  (3, 1, 4),
  (3, 2, 6),
  (3, 3, 4),
  (3, 4, 8),
  (3, 5, 5);

104	112	93
177	165	151
166	144	119

***************************************************
Me:
to transpose a matrix/table create a new table and load with row_num in col_num and vice versa

drop table btrans;

CREATE TABLE btrans (
row_num INT not null,
col_num INT not null,
value INT,
PRIMARY KEY(row_num, col_num)
);

insert into btrans(row_num,col_num,value) select col_num, row_num, value from b;

select * from btrans;

******************************************************
#https://spin.atomicobject.com/2014/06/24/gradient-descent-linear-regression/

*****************
# y = mx + b
# m is slope, b is y-intercept
def computeErrorForLineGivenPoints(b, m, points):
    totalError = 0
    for i in range(0, len(points)):
        totalError += (points[i].y - (m * points[i].x + b)) ** 2
    return totalError / float(len(points))


******************

def stepGradient(b_current, m_current, points, learningRate):
    b_gradient = 0
    m_gradient = 0
    N = float(len(points))
    for i in range(0, len(points)):
        b_gradient += -(2/N) * (points[i].y - ((m_current*points[i].x) + b_current))
        m_gradient += -(2/N) * points[i].x * (points[i].y - ((m_current * points[i].x) + b_current))
    new_b = b_current - (learningRate * b_gradient)
    new_m = m_current - (learningRate * m_gradient)
    return [new_b, new_m]


CREATE TABLE points (
x_num DECIMAL(20,16),
y_num DECIMAL(20,16)
);

CREATE OR REPLACE PROCEDURE GETLINEERR
    (IN YINT DECIMAL,
     IN SLOPE DECIMAL,
     OUT TOTALERROR DECIMAL(12,3))
  LANGUAGE SQL
BEGIN
  DECLARE C1 CURSOR FOR SELECT * FROM POINTS;
  DECLARE XPT DECIMAL(20,16);
  DECLARE YPT DECIMAL(20,16);
  DECLARE CONTINUE HANDLER FOR NOT FOUND
      SET EOF = 1;

  SET TOTALERROR = 0;
  OPEN C1;
  WHILE EOF = 0 DO
    FETCH FROM C1 INTO XPT,YPT;
    SET TOTALERROR = TOTALERROR + (YPT - (SLOPE * XPT + YINT));
  END WHILE;
  CLOSE C1;
END


