class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.33.tar.gz"
  sha256 "ae31e6368617776b43c82436c3736900067fada1289032f3ac3392f7380bcb58"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_ventura:  "526dd086eb4c9b11107323e3118d6eeba048b9135c44c0ba793f46f3546c42e1"
    sha256 arm64_monterey: "84fb181cec5c4efc81c3f0be627e21255ba7e4090b61564205d4208e647e97fb"
    sha256 arm64_big_sur:  "44f2bd5437aa38066903069838811074046ace0ca03401230d4957a85a9f7694"
    sha256 ventura:        "d9d8b0c6c0e0c28b46fd6af875f43f1935e05db27755a99e4cc62e3723e61059"
    sha256 monterey:       "a21a825d53e81277e1e04cf981acb1b94e42b7d00ef80646d9fd7cbbd402c8e7"
    sha256 big_sur:        "8ca519a1a536d064bf8d7fd4f33e453c7f1a735900c481b412a6d59d37a3f90f"
    sha256 x86_64_linux:   "39450da886eb0fe6f6677cd6239bc7f99c939a1f9686da9cb7ab7dfb3277baae"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@1.1"
  depends_on "zlib" # Zlib 1.2.12+
  depends_on "zstd"

  uses_from_macos "libedit"

  fails_with gcc: "5"

  # Fix for "Cannot find system zlib libraries" even though they are installed.
  # https://bugs.mysql.com/bug.php?id=110745
  patch :DATA

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

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end

__END__
diff --git a/cmake/zlib.cmake b/cmake/zlib.cmake
index 460d87a..36fbd60 100644
--- a/cmake/zlib.cmake
+++ b/cmake/zlib.cmake
@@ -50,7 +50,7 @@ FUNCTION(FIND_ZLIB_VERSION ZLIB_INCLUDE_DIR)
   MESSAGE(STATUS "ZLIB_INCLUDE_DIR ${ZLIB_INCLUDE_DIR}")
 ENDFUNCTION(FIND_ZLIB_VERSION)
 
-FUNCTION(FIND_SYSTEM_ZLIB)
+MACRO(FIND_SYSTEM_ZLIB)
   FIND_PACKAGE(ZLIB)
   IF(ZLIB_FOUND)
     ADD_LIBRARY(zlib_interface INTERFACE)
@@ -61,7 +61,7 @@ FUNCTION(FIND_SYSTEM_ZLIB)
         ${ZLIB_INCLUDE_DIR})
     ENDIF()
   ENDIF()
-ENDFUNCTION(FIND_SYSTEM_ZLIB)
+ENDMACRO(FIND_SYSTEM_ZLIB)
 
 MACRO (RESET_ZLIB_VARIABLES)
   # Reset whatever FIND_PACKAGE may have left behind.