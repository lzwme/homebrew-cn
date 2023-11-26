class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3440100.tar.gz"
  version "3.44.1"
  sha256 "63c3181633844adb5e36187f75b8f31a51cd32487992a26b89bf26b22ecdcf48"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "37c65a0b6310a5c838e61ab33679457ab8a402ac35096b027775e74d4185eca1"
    sha256 cellar: :any,                 arm64_ventura:  "72577ec6e7611e1f4704c9caba4eaca272b18fbb31a5713a88f74999cb848269"
    sha256 cellar: :any,                 arm64_monterey: "f3fc307f69df7c96731a0a9c65ad6142e4173e12f1f55ae815cc00607598715b"
    sha256 cellar: :any,                 sonoma:         "a01b39042ce752a75018b5a46a2bd6ce130b8db003562c518687fc9689a78cdb"
    sha256 cellar: :any,                 ventura:        "01313334f5675104e66d3708e4cfba9e9f0de3bc6bdfb7a14fca60755bf0936e"
    sha256 cellar: :any,                 monterey:       "d9705e9968256ab7b8eef4b3cb0358950a402f5f68f7f045c72fa76bd4ce956c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66e6b6065a69b0fbcc7b64b8c4f938233f86f4e234d719f02e69198d58c394f0"
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