class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3430000.tar.gz"
  version "3.43.0"
  sha256 "49008dbf3afc04d4edc8ecfc34e4ead196973034293c997adad2f63f01762ae1"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e6a7d708ca874fc883696409b8319d9ed9376ebfbe911739b50a202d3392fdad"
    sha256 cellar: :any,                 arm64_monterey: "92045cc54f60f0a5bb614eafa7f32bda112f63ca74cb546c2c6a3435c46b501f"
    sha256 cellar: :any,                 arm64_big_sur:  "1d46596e4c46cd560de16d9b9000fa282e7fcb4f7512e45f4ffd3a238a9de26b"
    sha256 cellar: :any,                 ventura:        "d2d619eaa851c53646f5e056733e467cd777e1d753b616c2437a876f9e02b13d"
    sha256 cellar: :any,                 monterey:       "9a30e2f13cece39c54235aee4b52eab97074e2381f1711106df962c36c83e93c"
    sha256 cellar: :any,                 big_sur:        "4c06f8a5234f56bb382d953ba8c2906fc66cf74e31d859dfcfb5fda9446ce345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35dcead7390fef5dd96c80f876b32fd988836e5820c1a6744edf10c7e95a004c"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  uses_from_macos "zlib"

  def install
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", %w[
      -DSQLITE_ENABLE_COLUMN_METADATA=1
      -DSQLITE_ENABLE_FTS3=1
      -DSQLITE_ENABLE_FTS3_PARENTHESIS=1
      -DSQLITE_ENABLE_JSON1=1
      -DSQLITE_ENABLE_RTREE=1
      -DSQLITE_ENABLE_UNLOCK_NOTIFY=1
      -DSQLITE_MAX_VARIABLE_NUMBER=250000
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