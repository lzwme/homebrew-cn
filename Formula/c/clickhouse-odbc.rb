class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https:github.comClickHouseclickhouse-odbc"
  # Git modules are all for bundled libraries so can use tarball without them
  url "https:github.comClickHouseclickhouse-odbcarchiverefstagsv1.2.1.20220905.tar.gz"
  sha256 "ca8666cbc7af9e5d4670cd05c9515152c34543e4f45e2bc8fa94bee90d724f1b"
  license "Apache-2.0"
  revision 4
  head "https:github.comClickHouseclickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "511592ca4aae49e95712ca4383ef893cc7c432a114d4e5d4e0ec43849a7abc6b"
    sha256 cellar: :any,                 arm64_sonoma:   "d1ec82bbcf45c1c3526a4699da073b5ce44de9c0d74b823d0350b7ca937dbffc"
    sha256 cellar: :any,                 arm64_ventura:  "be163859c30c1eb7b874d975147cf3cd3198fc02de5b24cbb0356ebdaa2ef371"
    sha256 cellar: :any,                 arm64_monterey: "c404681ad9b6d7028f1b82788aea502c01eb9aa7ef17867fdcbeefda20c7da17"
    sha256 cellar: :any,                 sonoma:         "79e87369497bb05b0a71d043cf02f7ff6d315d018ed93a2df0e138cb60559cfa"
    sha256 cellar: :any,                 ventura:        "ff86eef7168fa6415a078a683d1caf48b4ecc35ba32c054be755d9b6791b4716"
    sha256 cellar: :any,                 monterey:       "45d467672731adc68583f3592bdaf4d6132af3e9bdf965cdf9ec7e0ade577691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95eda36214b3988aecb8ad96eef4383f68c16fa1dbe8b014e4b4520f32dafc85"
  end

  depends_on "cmake" => :build
  depends_on "folly" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@3"
  depends_on "poco"

  on_macos do
    depends_on "libiodbc"
    depends_on "pcre2"
  end

  on_linux do
    depends_on "unixodbc"
  end

  fails_with :gcc do
    version "6"
  end

  def install
    # Remove bundled libraries
    %w[folly googletest nanodbc poco ssl].each { |l| rm_r(buildpath"contrib"l) }

    args = %W[
      -DCH_ODBC_PREFER_BUNDLED_THIRD_PARTIES=OFF
      -DCH_ODBC_THIRD_PARTY_LINK_STATIC=OFF
      -DICU_ROOT=#{Formula["icu4c"].opt_prefix}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]
    args += if OS.mac?
      ["-DODBC_PROVIDER=iODBC", "-DODBC_DIR=#{Formula["libiodbc"].opt_prefix}"]
    else
      ["-DODBC_PROVIDER=UnixODBC", "-DODBC_DIR=#{Formula["unixodbc"].opt_prefix}"]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"my.odbcinst.ini").write <<~EOS
      [ODBC Drivers]
      ClickHouse ODBC Test Driver A = Installed
      ClickHouse ODBC Test Driver W = Installed

      [ClickHouse ODBC Test Driver A]
      Description = ODBC Driver for ClickHouse (ANSI)
      Driver      = #{libshared_library("libclickhouseodbc")}
      Setup       = #{libshared_library("libclickhouseodbc")}
      UsageCount  = 1

      [ClickHouse ODBC Test Driver W]
      Description = ODBC Driver for ClickHouse (Unicode)
      Driver      = #{libshared_library("libclickhouseodbcw")}
      Setup       = #{libshared_library("libclickhouseodbcw")}
      UsageCount  = 1
    EOS

    (testpath"my.odbc.ini").write <<~EOS
      [ODBC Data Sources]
      ClickHouse ODBC Test DSN A = ClickHouse ODBC Test Driver A
      ClickHouse ODBC Test DSN W = ClickHouse ODBC Test Driver W

      [ClickHouse ODBC Test DSN A]
      Driver      = ClickHouse ODBC Test Driver A
      Description = DSN for ClickHouse ODBC Test Driver (ANSI)
      Url         = https:default:password@example.com:8443query?database=default

      [ClickHouse ODBC Test DSN W]
      Driver      = ClickHouse ODBC Test Driver W
      Description = DSN for ClickHouse ODBC Test Driver (Unicode)
      Url         = https:default:password@example.com:8443query?database=default
    EOS

    ENV["ODBCSYSINI"] = testpath
    ENV["ODBCINSTINI"] = "my.odbcinst.ini"
    ENV["ODBCINI"] = "#{ENV["ODBCSYSINI"]}my.odbc.ini"

    if OS.mac?
      ENV["ODBCINSTINI"] = "#{ENV["ODBCSYSINI"]}#{ENV["ODBCINSTINI"]}"

      assert_match "SQL>",
        pipe_output("#{Formula["libiodbc"].bin}iodbctest 'DSN=ClickHouse ODBC Test DSN A'", "exit\n")

      assert_match "SQL>",
        pipe_output("#{Formula["libiodbc"].bin}iodbctestw 'DSN=ClickHouse ODBC Test DSN W'", "exit\n")
    elsif OS.linux?
      assert_match "Connected!",
        pipe_output("#{Formula["unixodbc"].bin}isql 'ClickHouse ODBC Test DSN A'", "quit\n")

      assert_match "Connected!",
        pipe_output("#{Formula["unixodbc"].bin}iusql 'ClickHouse ODBC Test DSN W'", "quit\n")
    end
  end
end