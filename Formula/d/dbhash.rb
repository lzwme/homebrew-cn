class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3440200.zip"
  version "3.44.2"
  sha256 "73187473feb74509357e8fa6cb9fd67153b2d010d00aeb2fddb6ceeb18abaf27"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdb27915155e4a1ca7df3ec57a688ae160a20348e9709904e83565be33f9b87e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "858ff4c69d5801f41a3db92eb69182a73d33c67d6f036eea9ee531cc911cd28f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61f48c2bcc3dc535988c1cc000e0279dd803dc12c4f1999d8805aa128492ef1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "940fe8a3c5e909d1b9ecece8582eebbb0249372bfd3b30d5d11d449e848e4297"
    sha256 cellar: :any_skip_relocation, ventura:        "337180fa518b906f613ee03dfdeb9200e345cb7c3ad832e4db7c4ae42f10e74a"
    sha256 cellar: :any_skip_relocation, monterey:       "2d130b46b4ca03aaa587c9c717973cd1515ef0dd773e08c1c0129cb406f90edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a1784073e3a301912ff31c7a045a348c57a73e28cad4f4455fd344f3066cb08"
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