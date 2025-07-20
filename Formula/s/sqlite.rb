class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2025/sqlite-autoconf-3500300.tar.gz"
  version "3.50.3"
  sha256 "ec5496cdffbc2a4adb59317fd2bf0e582bf0e6acd8f4aae7e97bc723ddba7233"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d5ac21b30a733b24e58531bfdbe510ccbe14b72972e3b71ecad78a5243f6cfb1"
    sha256 cellar: :any,                 arm64_sonoma:  "17759620116ae72926fbcdef96aa7145c9919dda59e4fe0545f319844df990e6"
    sha256 cellar: :any,                 arm64_ventura: "aca8523f790a8042c7a1412257f24108100959407c3acabb5823cbccadf52d20"
    sha256 cellar: :any,                 sequoia:       "efdac2a067ddd79d2a844ba4124cb29b55cc817d9340e5da87f1134dea1cf426"
    sha256 cellar: :any,                 sonoma:        "0e4a86d2a03bd164dcf582c472090d76acaa66fe7d988954a07ca45b882d838f"
    sha256 cellar: :any,                 ventura:       "092fb4fa333028e779cff60ebf8f58dfd70939c86919ba708e53ef391c048d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30de509413be99c4033b4df15576c0db2c732330bad3bcbecc186f03ef525e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7cea8cedb8cadd9041d11effd55437bc79529a0813d06259106314b1b90798f"
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

    args = [
      "--enable-readline",
      "--disable-editline",
      "--enable-session",
      "--with-readline-cflags=-I#{Formula["readline"].opt_include}",
      "--with-readline-ldflags=-L#{Formula["readline"].opt_lib} -lreadline",
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/sqlite3.pc", prefix, opt_prefix
  end

  test do
    path = testpath/"school.sql"
    path.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end