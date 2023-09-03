class Sqliteodbc < Formula
  desc "ODBC driver for SQLite"
  homepage "https://ch-werner.homepage.t-online.de/sqliteodbc/"
  url "https://ch-werner.homepage.t-online.de/sqliteodbc/sqliteodbc-0.9999.tar.gz"
  sha256 "2c3cd6fd9d2be59d439122b0488788e5431b879a600f01117697763c5b563cf7"
  license "TCL"

  livecheck do
    url :homepage
    regex(/href=.*?sqliteodbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b0a8f9a64312af200f4055137047fbefb91d16ff0ae725c68860201553c67eb0"
    sha256 cellar: :any,                 arm64_monterey: "66da89464648d171f7c7db9d2e4eb0a284e73a70a74f59a5fcb19c9f92e3870f"
    sha256 cellar: :any,                 arm64_big_sur:  "7d345b9c5b48cf74eab1f16657cab8bf9352dfca7b2b14fc9da9e714dc38b14c"
    sha256 cellar: :any,                 ventura:        "d2befd3618c126838e53517eb552f5243735d6b790ac36f92f8299f33f51f266"
    sha256 cellar: :any,                 monterey:       "51b3ad012528a10185ae3d288bbdac21c232ca31a15bc2c864f6c361ea247091"
    sha256 cellar: :any,                 big_sur:        "2e557cba3fef6bebc851450e809252afc8fb98158d53ea3e1a56c306f9a12546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304e529c638e45f26761ca6838072f0c8015540aefab6173401ee9a0c162de1f"
  end

  depends_on "sqlite"
  depends_on "unixodbc"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_arm do
    # Added automake as a build dependency to update config files for ARM support.
    depends_on "automake" => :build
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  # Notified the author about the build patch
  patch :DATA

  def install
    if Hardware::CPU.arm?
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end

    lib.mkdir
    args = ["--with-odbc=#{Formula["unixodbc"].opt_prefix}",
            "--with-sqlite3=#{Formula["sqlite"].opt_prefix}"]
    args << "--with-libxml2=#{Formula["libxml2"].opt_prefix}" if OS.linux?

    system "./configure", "--prefix=#{prefix}", *args
    system "make"
    system "make", "install"
    lib.install_symlink lib/"libsqlite3odbc.dylib" => "libsqlite3odbc.so" if OS.mac?
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libsqlite3odbc.so")
    assert_equal "SUCCESS: Loaded #{lib}/libsqlite3odbc.so\n", output
  end
end

__END__
diff --git a/sqlite3odbc.c b/sqlite3odbc.c
index 79361da..fbe711a 100644
--- a/sqlite3odbc.c
+++ b/sqlite3odbc.c
@@ -13305,7 +13305,7 @@ drvdriverconnect(SQLHDBC dbc, SQLHWND hwnd,
 				   attas, sizeof (attas), ODBC_INI);
     }
 #endif
-    illag[0] = '\0';
+    ilflag[0] = '\0';
     getdsnattr(buf, "ilike", ilflag, sizeof (ilflag));
 #ifndef WITHOUT_DRIVERMGR
     if (dsn[0] && !ilflag[0]) {