class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https:github.comClickHouseclickhouse-odbc"
  # Git modules are all for bundled libraries so can use tarball without them
  url "https:github.comClickHouseclickhouse-odbcarchiverefstagsv1.2.1.20220905.tar.gz"
  sha256 "ca8666cbc7af9e5d4670cd05c9515152c34543e4f45e2bc8fa94bee90d724f1b"
  license "Apache-2.0"
  revision 6
  head "https:github.comClickHouseclickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c6b0acad4b807f6107d995f47eae04bdce3ad7c64c6f4a0cf31eb98dd7c2c2e"
    sha256 cellar: :any,                 arm64_sonoma:  "04ca343b2b2849c9a11510e111341dc1f119beccf9ca8a2d09e2d85f95432343"
    sha256 cellar: :any,                 arm64_ventura: "668def88586c374c2e51eb199bd908b65336029aa74de957b4b7b53e55eba806"
    sha256 cellar: :any,                 sonoma:        "4f8477fd4142bfb2ccd7f56f4deb8190a444f258e91697f689879fa65ad087e5"
    sha256 cellar: :any,                 ventura:       "34a27423851185c72717d6f0fc2eb2055d11846a0b5527024daa7065e68427d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "688ff9bea0da387640e6a46228e136b2a001740c33d75bdaec9232d1c83b4027"
  end

  depends_on "cmake" => :build
  depends_on "folly" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@76"
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

    icu4c_dep = deps.find { |dep| dep.name.match?(^icu4c(@\d+)?$) }
    args = %W[
      -DCH_ODBC_PREFER_BUNDLED_THIRD_PARTIES=OFF
      -DCH_ODBC_THIRD_PARTY_LINK_STATIC=OFF
      -DICU_ROOT=#{icu4c_dep.to_formula.opt_prefix}
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