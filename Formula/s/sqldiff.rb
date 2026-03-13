class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2026/sqlite-src-3520000.zip"
  version "3.52.0"
  sha256 "652a98ca833ed638809a52bec225a7f37799f71a995778f9ccb68ad03bd1fc11"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20810d26d7d0f5ac4c89fd36c1f53d5b80482f546ca40c519d06d6a4fa0390e1"
    sha256 cellar: :any,                 arm64_sequoia: "eea40ae84ace01a1baf895d01e20223dae5310a38ce2ce945bad79da7ae15951"
    sha256 cellar: :any,                 arm64_sonoma:  "e9b3bc0597a4195b5e5706d8d893908d571ec4a08ea8b1f55e8fcbe1bf4149da"
    sha256 cellar: :any,                 tahoe:         "24f59ea5d1c601940f7648873d3e0ef26545926d6d3cda9d7ca35a144b17e5d1"
    sha256 cellar: :any,                 sequoia:       "e316ba7cbdf4ea6c4cd4256517a3efbdd568006f4809f649d3f2598de4f02171"
    sha256 cellar: :any,                 sonoma:        "159014e1a6efa2253d140e1f230c597cf82fcce918cd44d671fb0f64aad7e50f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0faea85fb68459201ff0b39eaab5a6acd9b8068887cb6b755d1e4baf3a79fa23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2181db98ea7fbd1ae022e04190084bc6b168daab6212c29070ccd6561092f64"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end