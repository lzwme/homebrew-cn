class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2024/sqlite-src-3470200.zip"
  version "3.47.2"
  sha256 "e6a471f1238225f34c2c48c5601b54024cc538044368230f59ff0672be1fc623"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190d471fafdf8ff76be71ef4dd978bd7b4cee5928491187e33833a32461502a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2665ad3ed18493df985374d2a4a16601c69e80c0f2dba3760cf0fd0e7f31440"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be873cae3d2ff6418cdb6ca6d571ab96afe22a932a9fae942d6976709878edbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ecf747b6c10e41a7a1dad2a1cca3579228f84d1b249ecabe11150b5dbfcd67d"
    sha256 cellar: :any_skip_relocation, ventura:       "64397c6ffbb34a095d9bcba144ff229ff45770c472e9a430b33483af3e7cdb79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f14bc0093356db9130d01fddc89619700f483ad7bd2bb54504546f56412fddc1"
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