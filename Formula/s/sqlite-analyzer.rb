class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2026/sqlite-src-3530400.zip"
  version "3.53.4"
  sha256 "d18fa15aec74d8c17e1463f861095adc01b5ad190256acb4f91d22f0368d232b"
  license "blessing"
  revision 1

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "25a7e4b8b2a4d4d2c43e9e9d21e374a3ee52f54581d77f073d6b68ea02889b82"
    sha256 cellar: :any, arm64_tahoe:       "154c60f9ff4b9a3ad9a4bf1bee4a74c26adc6396335e3fb5a67db577d33ace09"
    sha256 cellar: :any, arm64_sequoia:     "6b3dc3c406a3974a50d1e094039cc5666c524354650f7e17d8b874e67baf65ee"
    sha256 cellar: :any, arm64_linux:       "08f1a98522d73ce29869d0c9f07d54291fa2ecc7a4b2be9d6d20c32baa25d412"
    sha256 cellar: :any, x86_64_linux:      "889bfcddc0f0d87ae9daecbd8b8adffcd378160d3c241ce1e45fb83df3d9cdbe"
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