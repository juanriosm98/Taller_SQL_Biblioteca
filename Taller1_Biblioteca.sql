-- CONSULTA 1
-- Obtener los nombres y apellidos de los usuarios
-- que han reservado un libro de la categoria Ficion

SELECT FirstName, LastName
FROM Users
WHERE UserID IN (
    SELECT UserID
    FROM Reservations
    WHERE BookID IN (
        SELECT BookID
        FROM Books
        WHERE CategoryID IN (
            SELECT CategoryID
            FROM BookCategories
            WHERE CategoryName = 'Fiction'
        )
    )
);

-- CONSULTA 2
-- Mostrar el titulo y autor de los libros prestados

SELECT Title, Author
FROM Books
WHERE BookID IN (
    SELECT BookID
    FROM Loans
);

-- CONSULTA 3
-- Libros reservados, pero que no han sido prestados

SELECT Title
FROM Books
WHERE BookID IN (
    SELECT BookID
    FROM Reservations
)
AND BookID NOT IN (
    SELECT BookID
    FROM Loans
);

-- CONSULTA 4
-- Libros prestados, pero que no han sido reservados

SELECT Title
FROM Books
WHERE BookID IN (
    SELECT BookID
    FROM Loans
)
AND BookID NOT IN (
    SELECT BookID
    FROM Reservations
);

-- CONSULTA 5
-- Mostrar todos los libros con su estado

SELECT Title,
       AvailableCopies,
       CASE
           WHEN AvailableCopies > 0 THEN 'Disponible'
           ELSE 'Agotado'
       END AS Estado
FROM Books;

-- CONSULTA 6
-- Usuarios y títulos de los libros reservados

SELECT U.FirstName, U.LastName,
       CASE
           WHEN EXISTS (
               SELECT 1
               FROM Loans L
               WHERE L.UserID = U.UserID
           ) THEN 'Activo'
           ELSE 'Sin actividad'
       END AS Estado
FROM Users U;

-- CONSULTA 7
-- Encontrar las categorias con mas de 3 libros

SELECT C.CategoryName,
       COUNT(B.BookID) AS TotalLibros
FROM BookCategories C
INNER JOIN Books B
    ON C.CategoryID = B.CategoryID
GROUP BY C.CategoryID, C.CategoryName
HAVING COUNT(B.BookID) > 3;

-- CONSULTA 8
-- Usuarios que tienen mas de 2 libros reservados

SELECT U.FirstName, U.LastName,
       COUNT(R.ReservationID) AS TotalReservas
FROM Users U
INNER JOIN Reservations R
    ON U.UserID = R.UserID
GROUP BY U.UserID, U.FirstName, U.LastName
HAVING COUNT(R.ReservationID) > 2;

    -- CONSULTA 9
--Mostrar un listado de los nombres de usuarios y los títulos de los libros que han sido prestados

SELECT U.FirstName, U.LastName, B.Title
FROM Users U
INNER JOIN Loans L
    ON U.UserID = L.UserID
INNER JOIN Books B
    ON L.BookID = B.BookID;;

    -- CONSULTA 10
--Mostrar los nombres de usuarios y los títulos de los libros que han reservado.

SELECT U.FirstName, U.LastName, B.Title
FROM Users U
INNER JOIN Reservations R
    ON U.UserID = R.UserID
INNER JOIN Books B
    ON R.BookID = B.BookID;


    -- CONSULTA 11
-- Listar todos los libros junto con el nombre del usuario que los reservó, si es que existe una reserva


SELECT B.Title, U.FirstName, U.LastName
FROM Books B
LEFT JOIN Reservations R
    ON B.BookID = R.BookID
LEFT JOIN Users U
    ON R.UserID = U.UserID;

    -- CONSULTA 12
-- Listar todos los usuarios y los títulos de los libros que han sido prestados, si es que existe un préstamo.

SELECT U.FirstName, U.LastName, B.Title
FROM Users U
LEFT JOIN Loans L
    ON U.UserID = L.UserID
LEFT JOIN Books B
    ON L.BookID = B.BookID;

    -- CONSULTA 13
-- Listar todos los libros junto con los nombres de los usuarios que los han reservado, incluyendo los libros que no tienen reservas

SELESELECT B.Title, U.FirstName, U.LastName
FROM Reservations R
RIGHT JOIN Books B
    ON R.BookID = B.BookID
LEFT JOIN Users U
    ON R.UserID = U.UserID;


--Consulta 14
--Listar todos los usuarios y los títulos de los libros que han sido prestados, incluyendo los usuarios que no tienen préstamos
SELECT U.FirstName, U.LastName, B.Title
FROM Loans L
RIGHT JOIN Users U
ON L.UserID = U.UserID
LEFT JOIN Books B
ON L.BookID = B.BookID;

-- Consulta 15
--Mostrar los títulos de todos los libros en mayúsculas.

SELECT UPPER(Title) AS Titulo_Mayusculas
FROM Books;

Consulta 16: 
Mostrar los nombres completos de los usuarios, uniendo el nombre y el apellido.

SELECT CONCAT(FirstName, ' ', LastName) AS Nombre_Completo
FROM Users;

Consulta 17: 
-- Mostrar cuántos días han pasado desde cada reserva.

SELECT ReservationID,
       ReservationDate,
       DATEDIFF(CURDATE(), ReservationDate) AS Dias_Transcurridos
FROM Reservations;

Consulta 18:
--Mostrar los préstamos que todavía no han sido devueltos.

SELECT *
FROM Loans
WHERE ReturnDate IS NULL;

Consulta 19:
Calcular el total de copias disponibles de libros por cada categoría.

SELECT C.CategoryName,
       SUM(B.AvailableCopies) AS TotalDisponibles
FROM BookCategories C
INNER JOIN Books B
    ON C.CategoryID = B.CategoryID
GROUP BY C.CategoryID, C.CategoryName;

consulta 20:
Mostrar el total de libros que ha prestado cada usuario.

SELECT U.FirstName, U.LastName,
       COUNT(L.LoanID) AS TotalPrestamos
FROM Users U
LEFT JOIN Loans L
    ON U.UserID = L.UserID
GROUP BY U.UserID, U.FirstName, U.LastName;