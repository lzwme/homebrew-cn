class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2025/sqlite-src-3500100.zip"
  version "3.50.1"
  sha256 "9090597773c60a49caebb3c1ac57db626fac4d97cb51890815a8b529a4d9c3dc"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "651e7ac1ab53cced71eea5e0803b8ce7b656fd2e31f9773eb32913501825d3e6"
    sha256 cellar: :any,                 arm64_sonoma:  "2cf2a064fe66957dd9450334c42d7b91efab80142e6899d2e4eb1be75f59ddd7"
    sha256 cellar: :any,                 arm64_ventura: "ec5674e6a86f3e7400a1431deb99befe9133a64c59886ea7ea4ec765f320cca1"
    sha256 cellar: :any,                 sequoia:       "c81408ffa207bc089af45a8e98857692e32416b5555c8bb020731880296f3e7f"
    sha256 cellar: :any,                 sonoma:        "6cc1677d3cb276e36f5c8758a9ae777c88ce7db557afd2a5c2cdd11c65ef2b88"
    sha256 cellar: :any,                 ventura:       "550f29b1cfa709d10e6a81d9ac39b6391c7805763e36f86fa3421290a58cc033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d834cbf47ebb76264a39101b81845fe1f75a2091f76dd0701c588e8954082703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a0a021f7b5b6e3d51e076103aa7d5ce729691c4e3b09ab86910c133f2327e26"
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