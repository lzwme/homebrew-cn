class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2026/sqlite-src-3520000.zip"
  version "3.52.0"
  sha256 "652a98ca833ed638809a52bec225a7f37799f71a995778f9ccb68ad03bd1fc11"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0de93f1ecdde2adcf2af78e05cfab4ccbc82469fa3ec64b7e5d07519d2b92e5f"
    sha256 cellar: :any,                 arm64_sequoia: "10684dbaa01d6d6c481d68aa27c57016317c87150ec70933b0973e7c2085d9cb"
    sha256 cellar: :any,                 arm64_sonoma:  "178ba5d7ced18e754866264f69ff6dbafa24a79d5bda726fb453f4debb051b9b"
    sha256 cellar: :any,                 tahoe:         "3e7f028dd3ade448847cf0d66966f83bcdf1cd7cb0d632ce92c3fa0145804bda"
    sha256 cellar: :any,                 sequoia:       "bfdf04e4a24ae16e1c5aeefd69e366958a562caadc4f6459f1312a52674d6a8c"
    sha256 cellar: :any,                 sonoma:        "b058bd2f041a5c702a4c9a90e0c560f1b9455508021c61e093c671e8e0262276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29ed628a2e5dc9ffa5a17fc221b49aaf21744431f1aca79be059fe8c42666f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7afdce2bcd88757a7704ac25cbc53e8b882308af49cb071aed54e0c459fc7847"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end