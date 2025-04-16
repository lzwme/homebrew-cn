class MysqlClientAT84 < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https:dev.mysql.comdocrefman8.4en"
  homepage "https:github.commysqlmysql-server"
  url "https:cdn.mysql.comDownloadsMySQL-8.4mysql-8.4.5.tar.gz"
  sha256 "53639592a720a719fdfadf2c921b947eac86c06e333202e47667852a5781bd1a"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.4"
  end

  bottle do
    sha256 arm64_sequoia: "098bd1fb85e596375605a98fd4b858f0ef637892e511bab32916bb3a89071de6"
    sha256 arm64_sonoma:  "8da66dc0bab291f44ad946bd885f7d329f5930731e19439e6477c4ed5f7844e1"
    sha256 arm64_ventura: "f51a3cb48ef59767363918d3c5b89d46b4f30f9d517a5bc7ca43e00008bb3fac"
    sha256 sonoma:        "78c3154c717f72d1fd324b07d8b46918b2c43c1461da84d0f27d88fcf18f4193"
    sha256 ventura:       "e68554c52c29cb5e4b3bd0a2d7a16490b768860558f3c6a510b6a767aed66d48"
    sha256 arm64_linux:   "a5432f30021d501b71f23d22708dc884e3d206afc0bc55d4edfd00e031d443aa"
    sha256 x86_64_linux:  "f2420644264a3b7c64112482ee3753ca4ff297dd6b0b8b7f8fbf6a84f7130ccb"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "libedit"

  on_linux do
    depends_on "libtirpc" => :build
  end

  def install
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DFORCE_INSOURCE_BUILD=1
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_DOCDIR=sharedoc#{name}
      -DINSTALL_INCLUDEDIR=includemysql
      -DINSTALL_INFODIR=shareinfo
      -DINSTALL_MANDIR=shareman
      -DINSTALL_MYSQLSHAREDIR=sharemysql
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mysql --version")
  end
end