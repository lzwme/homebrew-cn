class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2025/sqlite-src-3490200.zip"
  version "3.49.2"
  sha256 "c3101978244669a43bc09f44fa21e47a4e25cdf440f1829e9eff176b9a477862"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ae28f827d09d908f3da16c9b1a12433426a97dc60d0ac81c1911889ac927be36"
    sha256 cellar: :any,                 arm64_sonoma:  "2ace67ff9b9fb828fea069f75e3f145f34a75812064d5a2d4f2cab8f207645de"
    sha256 cellar: :any,                 arm64_ventura: "87ba3e3253e6cc53ee7e85080ec87479ca03ab731f7016e9078678791299bd51"
    sha256 cellar: :any,                 sequoia:       "2c287f8b1f91100678360da7d0bcaf3104184abfa988a4f14898d0d46b0c49ed"
    sha256 cellar: :any,                 sonoma:        "1d86fbd5e946a7350314e97f83d11391b6fda2057847e6becde9e2794781eabd"
    sha256 cellar: :any,                 ventura:       "3cc8606a4715a6fe538c30e706f3ed3623abc9e717d5de82e1798cd85bcc474c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8230ee5aafbb5843b8b18bd00eedf66192bd21cc0c52eaca7ea5204417b5641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c1b5ebde8a417626e5e7c5be1f91779587fa3e59f19b5fdd521a6c76be838a4"
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