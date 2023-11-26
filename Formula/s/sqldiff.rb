class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3440100.zip"
  version "3.44.1"
  sha256 "52aa53c59ec9be4c28e2d2524676cb2938558f11c2b4c00d8b1a546000453919"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de425e5f51b69ab9b08e7641d9fd4df750815e5a0c9f8f2b7fe5044ceca5d3a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a4f1c6dc98bfc24b03a0ab062d1a6f145dbb5b8908020f71aaeafba0f3cd898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88e283fc8d981cbd64e198592c8e8506b85681ab666f06734c4746160a0035d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "536d78d8a9e126bb38fe1dba829577d01e4dc861162a495ceea4af7f9375299f"
    sha256 cellar: :any_skip_relocation, ventura:        "38e40d1dbe6485a133a3305fd53812027ce1ff9bcd92c25f6c59ec6d7f1eb15f"
    sha256 cellar: :any_skip_relocation, monterey:       "1a372d3b7f47aefb1048ceac1d5a01dafe44d5281df7b51bb24365d0f2665490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbb91fc4b655a4b3b0143236b1c9c7ee4650f36f1784f6b90ac07e1974cfdbff"
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