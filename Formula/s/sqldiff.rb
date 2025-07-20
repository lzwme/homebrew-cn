class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2025/sqlite-src-3500300.zip"
  version "3.50.3"
  sha256 "119862654b36e252ac5f8add2b3d41ba03f4f387b48eb024956c36ea91012d3f"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6535768116d9f428a6a34c77c7eeac4d10f5a43b09d5ea74c832d0744d78591"
    sha256 cellar: :any,                 arm64_sonoma:  "7aa9518c860af4cb7186c55e4bb845649cdce1fc102ba7b934c2f78459693d76"
    sha256 cellar: :any,                 arm64_ventura: "a41e65da705257771171e243aec97d16316de9fa9d350b68307ec3042355c9a6"
    sha256 cellar: :any,                 sequoia:       "2e0e3eb0e0a1a4645d1d6ef9035bba4c45f86b2280c2ff12ce4cad94fd231fdc"
    sha256 cellar: :any,                 sonoma:        "aee846667a49a369baab1ffe60cf7546cf6e5d57dd86ca0e343a25cf916d6224"
    sha256 cellar: :any,                 ventura:       "0eeaa10f8766d2f34643ff4d323cd61d2f9a9e2fb079c58e2b87deacbfec459f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3a4ec1d0521239797b9d318eb012a0441120a790acf08a844964795913e7100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c56992ade9e4c0ca59044cf61152513ea9ad89cea42f17b83f9fd79603a66bf8"
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