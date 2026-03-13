class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2026/sqlite-src-3520000.zip"
  version "3.52.0"
  sha256 "652a98ca833ed638809a52bec225a7f37799f71a995778f9ccb68ad03bd1fc11"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f9b23c4c345065c6ad7a2aef6b29814c7b426bbc268a6923d9be1a28c7170e7"
    sha256 cellar: :any,                 arm64_sequoia: "756edebe091a2bab2a10e1bbd2c83e5f378340b5d653ddef5ea70494b4c10baf"
    sha256 cellar: :any,                 arm64_sonoma:  "53ffa2bfcb22d677c2e2ecba8e6f21a87c43e777b6269235752d11a605dcf5dd"
    sha256 cellar: :any,                 sonoma:        "4ca9aec3a0c29a973f9bb6e195f49bb7d2a9bbf0a597f12c5a0a8a50796af3cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a058c75804d067e43ff6d932b8da98c759e935f04f371583ab38b74b2f221242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b36902a5502cd5792de9ce1f01be2b3613c7aefdc76cc6e9d19a39b54795e3c"
  end

  depends_on "tcl-tk"
  uses_from_macos "sqlite" => :test

  on_macos do
    depends_on "libtommath"
  end

  def install
    system "./configure", "--with-tcl=#{Formula["tcl-tk"].opt_lib}", *std_configure_args
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