class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2026/sqlite-autoconf-3520000.tar.gz"
  version "3.52.0"
  sha256 "f6b50b0c103392af32a8be15b2b9d25959de9a00a70c3979128aafeaa5338b3f"
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
    sha256 cellar: :any,                 arm64_tahoe:   "6f216497d6123e4142e3ef9e813a62cfe3caa671b23181dd561634c7caaa0588"
    sha256 cellar: :any,                 arm64_sequoia: "b369d834fb16f482aab47157153f60fb0b2e79473a5bf773dee8d2b459d37feb"
    sha256 cellar: :any,                 arm64_sonoma:  "7f973aa2a36472cf48531368704517a488654664c14319f781e265c64d663077"
    sha256 cellar: :any,                 tahoe:         "43f9b450624df90aec515b3d8ae86d98627136eeedbb2f9eb7d1dc192ebd2d99"
    sha256 cellar: :any,                 sequoia:       "d4e3408cad162c8e3de3edc8d730d906b6b8c6ad18a15c590463dc96e284b8f9"
    sha256 cellar: :any,                 sonoma:        "40aa845b3d21266f211fa751d9c9a721806064c1f6400953b78782dc388a9377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b610005e770ea11d6a035de8abd9c497bcb8d038279916c560c97fc48a8c7b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a218b752fa9462ba6b22002f55b4c76c0df2554e5e0b8b951d085dcb9feed7cf"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      -DSQLITE_ENABLE_GEOPOLY=1
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
    args << "--soname=legacy" if OS.linux?

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