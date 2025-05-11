class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2025/sqlite-src-3490200.zip"
  version "3.49.2"
  sha256 "c3101978244669a43bc09f44fa21e47a4e25cdf440f1829e9eff176b9a477862"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ef62a84468fd2e58d2c5fd5ebdadb2171c3be8c29f893fb1275ba4d9204fc08"
    sha256 cellar: :any,                 arm64_sonoma:  "2fb3577dd9cce4cf52a5fb1c77b988b87b0f7cccf9fa2e41fa5eb45806760efa"
    sha256 cellar: :any,                 arm64_ventura: "76813bf4ff104932e7abfcb8d77fe89cbb87f0effa2fef532830b19472428617"
    sha256 cellar: :any,                 sequoia:       "20eac7abca9782511b6173d380bc76b631340c0e2e4f42496f56191c85f433ce"
    sha256 cellar: :any,                 sonoma:        "23c11e3e7e84c7b809698ac48ca4a6ea1f24515328234bfffdd55860bec5eddd"
    sha256 cellar: :any,                 ventura:       "8bef608a453820084aa38325ce635802e9c97634045d9edfa1f76934915660ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f605a3572f0f0da27a0b3e1834394af63e243360c4123e022547b36dca47d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d0cb48d7e011b83a067cfb5880ee3f9cc949996084ddcd7fd03b46893c3d68b"
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