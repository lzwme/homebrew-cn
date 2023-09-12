class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3430100.tar.gz"
  version "3.43.1"
  sha256 "46db2f10f306e163e4571b8974d44cd37078aae04295bbf08b253655df3265f4"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b18db642fabe5b3c6dd77843e421ae39660877a4e1791476dc97610b154d74c0"
    sha256 cellar: :any,                 arm64_monterey: "8e0ece1599c8bbf51c97769cdd6e330b128c73a8eb6fbd07e87987c5e4e245bb"
    sha256 cellar: :any,                 arm64_big_sur:  "06292c25788cbe554212f04d785dbeceff1e6ed9a625f2b4e04a94f4ddd59878"
    sha256 cellar: :any,                 ventura:        "6e9a3355935a2483e52c7d8129aeca3cddf3a0e5de2a845a6c1176f6b44ff75a"
    sha256 cellar: :any,                 monterey:       "2034ce5a2c0eac1cb4e38e1380ea2840a2084428bcd26eb42ec44c3a0f6c674c"
    sha256 cellar: :any,                 big_sur:        "9c8987e8de456588f62639902c73f6c672c262d41aaae5c7c1ba9bee5e1826b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d10db26a3e9a34b60435ebde8ddafa9a5f8441ff975efdd212daf9eaa82fdb"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  uses_from_macos "zlib"

  def install
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", %w[
      -DSQLITE_ENABLE_API_ARMOR=1
      -DSQLITE_ENABLE_COLUMN_METADATA=1
      -DSQLITE_ENABLE_DBSTAT_VTAB=1
      -DSQLITE_ENABLE_FTS3=1
      -DSQLITE_ENABLE_FTS3_PARENTHESIS=1
      -DSQLITE_ENABLE_FTS5=1
      -DSQLITE_ENABLE_JSON1=1
      -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1
      -DSQLITE_ENABLE_RTREE=1
      -DSQLITE_ENABLE_STAT4=1
      -DSQLITE_ENABLE_UNLOCK_NOTIFY=1
      -DSQLITE_MAX_VARIABLE_NUMBER=250000
      -DSQLITE_USE_URI=1
    ].join(" ")

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-dynamic-extensions
      --enable-readline
      --disable-editline
      --enable-session
    ]

    system "./configure", *args
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/sqlite3.pc", prefix, opt_prefix
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end