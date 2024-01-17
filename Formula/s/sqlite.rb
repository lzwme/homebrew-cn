class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2024/sqlite-autoconf-3450000.tar.gz"
  version "3.45.0"
  sha256 "72887d57a1d8f89f52be38ef84a6353ce8c3ed55ada7864eb944abd9a495e436"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0257a189a2b5609bb8d2dfecfe23174e868a9b1c65bd621ffdfb24483821b6df"
    sha256 cellar: :any,                 arm64_ventura:  "2d9deb84364a7b9404528e171243a591ccc6cb8b4ba73433ec57fd0817b57615"
    sha256 cellar: :any,                 arm64_monterey: "d210de870cbd6765861dd5feb1158c819491dcf46ee8795149dbb2f49b693844"
    sha256 cellar: :any,                 sonoma:         "6fac6907a3c95224261a411185e71a23f85feefba3cbf94b5959407d475a77a0"
    sha256 cellar: :any,                 ventura:        "9ac3dc7027c4843de5a4f3b035f2af7b2434f5a2d11d9836a7d2e5f64c332cdb"
    sha256 cellar: :any,                 monterey:       "4a1d78cb59cf42269fde057de8568f39ff8190850a06b75758044a969987ebde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b31a8f263ba62359789b56e9e6a646b7dcb2ad962933b372656c9c8e7ed55d3e"
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