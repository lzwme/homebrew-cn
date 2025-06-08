class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2025/sqlite-autoconf-3500100.tar.gz"
  version "3.50.1"
  sha256 "00a65114d697cfaa8fe0630281d76fd1b77afcd95cd5e40ec6a02cbbadbfea71"
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
    sha256 cellar: :any,                 arm64_sequoia: "13d6403cd7df65d989386b2ccd59108056dda577b90104b479ecbcdeb6d867bb"
    sha256 cellar: :any,                 arm64_sonoma:  "b15e1a81d955db100a6c1450b2a6bcafed2a44a007612c11eb3cb260634b8a73"
    sha256 cellar: :any,                 arm64_ventura: "c0cec07b3debc8cedda83319db0cddf0384826ea64b28f2cba9b934f35d4c34a"
    sha256 cellar: :any,                 sequoia:       "550cee3143c8432be0f904cbe88c40ee00405ba0b015c9458dfb3e70df27b2e5"
    sha256 cellar: :any,                 sonoma:        "b89f7c9b8e71f33e7bd1c6890e242c855b2cefb95b7a5511a336c5e109aeff4d"
    sha256 cellar: :any,                 ventura:       "c169308ac7557751e250c567384d1129783121ba7da4e5d5a01086ba527b34a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "507de5de7071282b40ed5eb1279842395d5fc7c25c996f6d93d7f8878e3374c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b61986648f28fe065a695afa9796ca7c817d18411be79b4a22d9339cb4bc497"
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