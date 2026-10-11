class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2026/sqlite-src-3540000.zip"
  version "3.54.0"
  sha256 "8847659821e0c5116bd14a94644c82ba932b2d9a05ac81af2e34af814aad7c58"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "df5c1e1e2d979f12e4dc4ba529c17a01bf9ca8d2a1ab7fb341db9550a3769b01"
    sha256 cellar: :any, arm64_tahoe:       "f94427de8aad841f5f005827093c19782e690ace6ac7ebdcde6570e3727b75af"
    sha256 cellar: :any, arm64_sequoia:     "15a0d6eb7905ff09b38241573461bd180d42782a68228766ca17e95c480027d7"
    sha256 cellar: :any, arm64_linux:       "3b9790fa38a934f9ec60adb89ff1ea6718a801b9e669630a3d1529d64d9514ea"
    sha256 cellar: :any, x86_64_linux:      "b9a7debebb04ff155f8f1805f290c5aa596e123e8101d16dd09ad3502894df86"
  end

  depends_on "tcl-tk"
  uses_from_macos "sqlite" => :test

  on_macos do
    depends_on "libtommath"
  end

  def install
    system "./configure", "--with-tcl=#{formula_opt_lib("tcl-tk")}", *std_configure_args
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    SQL
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end