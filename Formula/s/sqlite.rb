class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3440000.tar.gz"
  version "3.44.0"
  sha256 "b9cd386e7cd22af6e0d2a0f06d0404951e1bef109e42ea06cc0450e10cd15550"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cba484fca9a7f63270dd7f1bd9d2c68059d3c206ebff66db1b0560e477303801"
    sha256 cellar: :any,                 arm64_ventura:  "6f82ff67c5b161e9f7d36a1b10c66de756806d6325d4f5233eb0edfb3e4145a9"
    sha256 cellar: :any,                 arm64_monterey: "02e519ae08edb0075f344ed3a942e810e236ca02f519d8e4bffc58ffefe75fc1"
    sha256 cellar: :any,                 sonoma:         "a65407f49c72002c0b834bf03215260117f18f54ffbc4da6c74d4b4bfdcc1b47"
    sha256 cellar: :any,                 ventura:        "6384c3b7a644d789d58cb1b1c304dcd8a1fe8f586a6d9d9569d5f3a842681f5c"
    sha256 cellar: :any,                 monterey:       "f4acceb7923f75378f6e1c22d6496d167b32e908064e0ec3bf09bea3cc2ccd64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0450f828eaf1c1ab73488add39bb240b99cb6750aa973e8253e07151fc288ce7"
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