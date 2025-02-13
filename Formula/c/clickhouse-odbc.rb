class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https:github.comClickHouseclickhouse-odbc"
  # Git modules are all for bundled libraries so can use tarball without them
  url "https:github.comClickHouseclickhouse-odbcarchiverefstagsv1.2.1.20220905.tar.gz"
  sha256 "ca8666cbc7af9e5d4670cd05c9515152c34543e4f45e2bc8fa94bee90d724f1b"
  license "Apache-2.0"
  revision 8
  head "https:github.comClickHouseclickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1185466785c3f5c56f7661e40bae6746b10579364030b4ed8ea456a2ce13d7e"
    sha256 cellar: :any,                 arm64_sonoma:  "8adeef554e1dd5f037ecdbbef0f9813eb5f008484dbb70059d9b56f21ac74231"
    sha256 cellar: :any,                 arm64_ventura: "2775d4fe0aee5bd86de1438d5735968a68bd6f7c45a38482935572f1132142f9"
    sha256 cellar: :any,                 sonoma:        "d7a0ffe3d1dbf29d20c3b947689881c5d15c5fa81c731e0b942bd0ed59ca851d"
    sha256 cellar: :any,                 ventura:       "32e97d139ff2b07e24342f84327f71578ace5a0d0466fcefbae9bdcc4b2e1853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20dfbb88c417ca8fdfa9fe4f186a84baa09d02f856a54d7251d3fdfa9b91be61"
  end

  depends_on "cmake" => :build
  depends_on "folly" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@76"
  depends_on "openssl@3"
  depends_on "poco"
  depends_on "utf8proc"

  on_macos do
    depends_on "libiodbc"
    depends_on "pcre2"
  end

  on_linux do
    depends_on "unixodbc"
  end

  # build patch for utf8proc, no needed for newer version, as folly got removed per https:github.comClickHouseclickhouse-odbcpull456
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesc76519fcbfa664cd37a8901deb76403b1af1bec1clickhouse-odbc1.2.1.20220905-Utf8Proc.patch"
    sha256 "29f3aeaa05609d53b942903868cb52ddcfcb3b35d32e8075d152cd2ca0ff5242"
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
    (testpath"my.odbcinst.ini").write <<~INI
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
    INI

    (testpath"my.odbc.ini").write <<~INI
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
    INI

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