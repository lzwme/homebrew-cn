class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2025/sqlite-src-3490000.zip"
  version "3.49.0"
  sha256 "bec0262d5b165b133d6f3bdb4339c0610f4ac3d50dee53e8ad148ece54a129d0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47d36dd35f22bdae67895ad3fc3345db0a0f567b2bd215792e462d81709531f3"
    sha256 cellar: :any,                 arm64_sonoma:  "e9477ae67dab3b0481e5e7b7396e8f4d13960604066ef0a3c996d62e60ffe864"
    sha256 cellar: :any,                 arm64_ventura: "2d770c884ff6aa6f130737e6bc82f0daff0ba9533705f29851f88c7bf01557ce"
    sha256 cellar: :any,                 sonoma:        "32d7596edc234ad96fe43e6022e444d8f1eca7af3525be9813ab01ba861344b8"
    sha256 cellar: :any,                 ventura:       "048a5f98ee6f8a4bccf6d5979634156fab3f80d97affd1ebb8dabbfe3d891473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94a073dd819836cada5f27b9de22e537cc876be3774cbf55ee1b3620f87c67fb"
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