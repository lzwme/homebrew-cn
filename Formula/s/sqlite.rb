class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2025/sqlite-autoconf-3490200.tar.gz"
  version "3.49.2"
  sha256 "5c6d8697e8a32a1512a9be5ad2b2e7a891241c334f56f8b0fb4fc6051e1652e8"
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
    sha256 cellar: :any,                 arm64_sequoia: "efe9021681f4fc983b282f40ea62713f9cde2fae38436b4ee884737f76f56500"
    sha256 cellar: :any,                 arm64_sonoma:  "80fbe2514bdfccd2306a829b994e7b5d631345a11cfe62e26d56ca980bf6a49d"
    sha256 cellar: :any,                 arm64_ventura: "c57fe253970bba86619d0ee62a5344074801de8260fcd7210d779973780d30d5"
    sha256 cellar: :any,                 sequoia:       "4ce1095909a4a45d39d691c537ec5d526531a64ea0effa27a2374a4de1f8c580"
    sha256 cellar: :any,                 sonoma:        "fbf7a928baca989555ec91e9469a3d96682865d53e0072da19aae63a1066f0a2"
    sha256 cellar: :any,                 ventura:       "67eb3623e2d69ad3896fee39f4c7a38e7121c1738af7f57baab47a72b17e2b7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b3f3bf1656a66e99837807d73422ae8f3c51277907bd928d6cccb68e9853e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "347e2e03572231f7045186c692844fe05fb33856c578af85eab861790385065c"
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