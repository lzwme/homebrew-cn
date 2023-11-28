class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.2/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.2/mysql-boost-8.2.0.tar.gz"
  sha256 "9a6fe88c889dfb54a8ee203a3aaa2af4d21c97fbaf171dadaf5956714552010e"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_sonoma:   "3f1573753d2b4886ac49417031bae3f6ba6dd42f737c3abaa0abdccb2d351894"
    sha256 arm64_ventura:  "dbcb826ebc8fd2bda4e25c1ab1787348ff1c64f98f1372079dd410276e5ceb2a"
    sha256 arm64_monterey: "1497501969ebe84479320e8c04f50a1c355bd0308d9d03ed111b4a38eab3fb06"
    sha256 sonoma:         "61346247d687aa1e6c86d63e195e0cc240a83132173a747295b37b33b54e646c"
    sha256 ventura:        "01c2730e6c623e4a7b15db55ec7db70e85956a558f56809809eb320734c8c74e"
    sha256 monterey:       "098e016430975ee9e142f3d26c4f03f02e750f84c7e8f9a7bbec3b9dad1cd236"
    sha256 x86_64_linux:   "fd19a7a5711362f13fb1c10ff7c01d15b048103cc911a5302796c0c5ab9a0369"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.12+
  depends_on "zstd"

  uses_from_macos "libedit"

  fails_with gcc: "5"

  def install
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DFORCE_INSOURCE_BUILD=1
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_LIBEVENT=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Fix bad linker flags in `mysql_config`.
    # https://bugs.mysql.com/bug.php?id=111011
    inreplace bin/"mysql_config", "-lzlib", "-lz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end