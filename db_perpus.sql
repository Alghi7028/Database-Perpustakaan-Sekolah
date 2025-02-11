-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 11, 2025 at 03:21 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_perpus`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `daftar_semua_buku` ()   BEGIN
    SELECT b.ID_Buku, b.Judul_Buku, b.Penulis, b.Kategori, b.Stok, 
           IFNULL(COUNT(p.ID_Peminjaman), 0) AS jumlah_dipinjam
    FROM buku b
    LEFT JOIN peminjaman p ON b.id_buku = p.ID_Buku
    GROUP BY b.ID_Buku, b.Judul_Buku, b.Penulis, b.Penulis, b.Kategori, b.Stok;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `daftar_semua_siswa` ()   BEGIN
    SELECT s.ID_Siswa, s.Nama, s.Kelas,  
           IFNULL(COUNT(p.id_peminjaman), 0) AS jumlah_peminjaman
    FROM siswa s
    LEFT JOIN peminjaman p ON s.ID_Siswa = p.ID_Peminjaman
    GROUP BY s.ID_Siswa, s.Nama, s.Kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `daftar_siswa_peminjam` ()   BEGIN
    SELECT DISTINCT s.ID_Siswa, s.Nama, s.Kelas
    FROM siswa s
    JOIN peminjaman p ON s.ID_Siswa = p.ID_Peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deletebuku` (IN `id_buku` INT)   BEGIN
	DELETE FROM buku WHERE ID_Buku = id_buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deletepeminjaman` (IN `id_peminjaman` INT)   BEGIN
	DELETE FROM buku WHERE ID_Peminjaman = id_peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deletesiswa` (IN `id_siswa` INT)   BEGIN
	DELETE FROM buku WHERE ID_Siswa = id_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertbuku` (IN `Judul_Buku` VARCHAR(100), IN `Penulis` VARCHAR(50), IN `Kategori` VARCHAR(50), IN `Stok` INT)   BEGIN
	INSERT INTO buku(Judul_Buku, Penulis, Kategori, Stok)
    VALUES(Judul_Buku, Penulis, Kategori, Stok);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertpeminjaman` (IN `ID_Siswa` INT, IN `ID_Buku` INT, IN `Tanggal_Pinjam` DATE, IN `Tanggal_Kembali` DATE, IN `Status` VARCHAR(50))   BEGIN
	INSERT INTO peminjaman(ID_Siswa, ID_Buku, Tanggal_Pinjam, Tanggal_Kembali, Status)
    VALUES(ID_Siswa, ID_Buku, Tanggal_Pinjam, Tanggal_Kembali, Status);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertsiswa` (IN `Nama` VARCHAR(50), IN `Kelas` VARCHAR(50))   BEGIN
	INSERT INTO siswa (Nama, Kelas)
    VALUES (Nama, Kelas);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `kembalikan_buku` (IN `p_id_peminjaman` INT)   BEGIN
   
    DECLARE v_id_buku INT;

   
    SELECT ID_Buku INTO v_id_buku
    FROM peminjaman
    WHERE ID_Peminjaman = p_id_peminjaman;

    
    UPDATE peminjaman
    SET Status = 'Dikembalikan',
        Tanggal_Kembali = CURRENT_DATE()
    WHERE ID_Peminjaman = p_id_peminjaman;

   
    UPDATE buku
    SET Stok = Stok + 1
    WHERE ID_Buku = v_id_buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectbuku` ()   BEGIN
	SELECT * FROM buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectpeminjaman` ()   BEGIN
	SELECT * FROM peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectsiswa` ()   BEGIN
	SELECT * FROM siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updatebuku` (IN `id` INT, IN `judul_Buku` VARCHAR(100), IN `penulis` VARCHAR(50), IN `kategori` VARCHAR(50), IN `stok` INT)   BEGIN
	UPDATE buku SET Judul_Buku = judul_Buku, Penulis = penulis, Kategori = kategori, Stok = stok WHERE ID_Buku = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updatepeminjaman` (IN `idp` INT, IN `ids` INT, IN `id` INT, IN `tp` DATE, IN `tk` DATE, IN `status` VARCHAR(50))   BEGIN
	UPDATE buku SET ID_Siswa = ids, ID_Buku = id, Tanggal_Pinjam = tp, Tanggal_Kembali = tk, Status = status WHERE ID_Peminjaman = idp;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updatesiswa` (IN `ids` INT, IN `nama` VARCHAR(50), IN `kelas` VARCHAR(50))   BEGIN
	UPDATE buku SET Nama = nama, Kelas = kelas WHERE ID_Siswa = ids;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `ID_Buku` int NOT NULL,
  `Judul_Buku` varchar(100) DEFAULT NULL,
  `Penulis` varchar(50) DEFAULT NULL,
  `Kategori` varchar(50) DEFAULT NULL,
  `Stok` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`ID_Buku`, `Judul_Buku`, `Penulis`, `Kategori`, `Stok`) VALUES
(1, 'Algoritma dan Pemrograman', 'Andi Wijaya', 'Teknologi', 5),
(2, 'Dasar - dasar Database', 'Budi Santoso', 'Teknologi', 7),
(3, 'Matematika Diskrit', 'Rina Sari', 'Matematika', 4),
(4, 'Sejarah Dunia', 'Jhon Smith', 'Sejarah', 3),
(5, 'Pemrograman Web dengan PHP', 'Eko Prasetyo', 'Teknologi', 8),
(6, 'Sistem Operasi', 'Dian Kurniawan', 'Teknologi', 6),
(7, 'Jaringan Komputer', 'Ahmad Fauzi', 'Teknologi', 5),
(8, 'Cerita Rakyat Nusantara', 'Lestari Dewi', 'Sastra', 9),
(9, 'Bahasa Inggris Untuk Pemula', 'Jane Doe', 'Bahasa', 10),
(10, 'Biologi Dasar', 'Budi Rahman', 'Sains', 7),
(11, 'Kimia Organik', 'Siti Aminah', 'Sains', 5),
(12, 'Teknik Elektro', 'Ridwan Hakim', 'Teknik', 6),
(13, 'Fisika Modern', 'Albert Einstein', 'sains', 4),
(14, 'Manajemen waktu', 'Stevan Covey', 'Pengembangan', 8),
(15, 'Strategi Belajar Efektif', 'Tony Buzan', 'Pendidikan', 6);

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `ID_Peminjaman` int NOT NULL,
  `ID_Siswa` int DEFAULT NULL,
  `ID_Buku` int DEFAULT NULL,
  `Tanggal_Pinjam` date DEFAULT NULL,
  `Tanggal_Kembali` date DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`ID_Peminjaman`, `ID_Siswa`, `ID_Buku`, `Tanggal_Pinjam`, `Tanggal_Kembali`, `Status`) VALUES
(1, 11, 2, '2025-02-01', '2025-02-08', 'Dipinjam'),
(2, 2, 5, '2025-01-08', '2025-02-04', 'Dikembalikan'),
(3, 3, 8, '2025-02-02', '2025-02-09', 'Dipinjam'),
(4, 4, 10, '2025-01-30', '2025-02-06', 'Dikembalikan'),
(5, 5, 3, '2025-01-25', '2025-02-01', 'Dikembalikan'),
(6, 15, 7, '2025-02-01', '2025-02-08', 'Dipinjam'),
(7, 7, 1, '2025-01-29', '2025-02-05', 'Dikembalikan'),
(8, 8, 9, '2025-02-03', '2025-02-10', 'Dipinjam'),
(9, 13, 4, '2025-01-27', '2025-02-03', 'Dikembalikan'),
(10, 10, 11, '2025-02-01', '2025-02-08', 'Dipinjam'),
(11, 14, 1, '2025-02-01', '2025-02-10', 'Dikembalikan'),
(12, 1, 1, '2025-03-02', '2025-02-10', 'Dikembalikan'),
(13, 1, 1, '2025-03-02', '2025-02-07', 'Dikembalikan');

--
-- Triggers `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `kurangi_stok_buku` AFTER INSERT ON `peminjaman` FOR EACH ROW BEGIN
    UPDATE buku 
    SET Stok = Stok - 1
    WHERE id_buku = NEW.Id_Buku AND Stok > 0;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tambah_stok_buku` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    IF OLD.Status = 'Dipinjam' AND NEW.Status = 'Dikembalikan' THEN
        UPDATE buku 
        SET Stok = Stok + 1
        WHERE id_buku = NEW.ID_Buku;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `siswa`
--

CREATE TABLE `siswa` (
  `ID_Siswa` int NOT NULL,
  `Nama` varchar(50) DEFAULT NULL,
  `Kelas` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `siswa`
--

INSERT INTO `siswa` (`ID_Siswa`, `Nama`, `Kelas`) VALUES
(1, 'Andi Saputra', 'X-RPL'),
(2, 'Budi Wijaya', 'X-TKJ'),
(3, 'Citra Lestari', 'XI-RPL'),
(4, 'Dewi Kurniawan', 'XI-TKJ'),
(5, 'Eko Prasetyo', 'XII-RPL'),
(6, 'Farhan Maulana', 'XII-TKJ'),
(7, 'Gita Permata', 'X-RPL'),
(8, 'Hadi Sucipto', 'X-TKJ'),
(9, 'Intan Permadi', 'XII-RPL'),
(10, 'Joko Santoso', 'XI-TKJ'),
(11, 'Kartika Sari', 'XII-RPL'),
(12, 'Lintang Putri', 'XII-TKJ'),
(13, 'Muhammad Rizky', 'X-RPL'),
(14, 'Novi Andriana', 'X-TKJ'),
(15, 'Olivia Hernanda', 'XI-RPL');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`ID_Buku`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`ID_Peminjaman`);

--
-- Indexes for table `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`ID_Siswa`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `ID_Buku` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `ID_Peminjaman` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `siswa`
--
ALTER TABLE `siswa`
  MODIFY `ID_Siswa` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
