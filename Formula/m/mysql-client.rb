class MysqlClient < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https:dev.mysql.comdocrefman9.3en"
  homepage "https:github.commysqlmysql-server"
  url "https:cdn.mysql.comDownloadsMySQL-9.3mysql-9.3.0.tar.gz"
  sha256 "1a3ee236f1daac5ef897c6325c9b0e0aae486389be1b8001deb3ff77ce682d60"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_sequoia: "7213d0e8ee62da27799aa432fa730f52923c1dc67c07a7ba28b12a00fb3b687e"
    sha256 arm64_sonoma:  "608f5e77f5402aa33077b4c0db91ebe1e1c032e04534a167879e27494279d776"
    sha256 arm64_ventura: "eefebca0be8b11bb7c6e48471fabecfb109b37326a2b137ee0e3dd0870c0b9e7"
    sha256 sonoma:        "aef0b032afdee3c5ca2c1ace18c1951d10a415a6fa5958b3dc0df197fc053f15"
    sha256 ventura:       "bff9a70b2e67a182de68c67d1610d7fe7c4e81a62d273a9f7a87764df355ce5b"
    sha256 arm64_linux:   "5d0b68e68bdca08b9aead388108e7ac2f6a50ba90545bd45137a1aa2dee1792d"
    sha256 x86_64_linux:  "9e4f76f7c086ebf5fc1446e1e653964f4a4ff1d07fa370b09b4fd2b7c137ee8e"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "libedit"

  on_ventura :or_older do
    depends_on "llvm" => :build
    fails_with :clang do
      cause <<~EOS
        std::string_view is not fully compatible with the libc++ shipped
        with ventura, so we need to use the LLVM libc++ instead.
      EOS
    end
  end

  on_linux do
    depends_on "libtirpc" => :build
    depends_on "krb5"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    if OS.linux?
      # Disable ABI checking
      inreplace "cmakeabi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"
    elsif MacOS.version <= :ventura
      ENV.llvm_clang
    end

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_DOCDIR=sharedoc#{name}
      -DINSTALL_INCLUDEDIR=includemysql
      -DINSTALL_INFODIR=shareinfo
      -DINSTALL_MANDIR=shareman
      -DINSTALL_MYSQLSHAREDIR=sharemysql
      -DWITH_AUTHENTICATION_CLIENT_PLUGINS=yes
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mysql --version")
  end
end