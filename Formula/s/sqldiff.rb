class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2024/sqlite-src-3470200.zip"
  version "3.47.2"
  sha256 "e6a471f1238225f34c2c48c5601b54024cc538044368230f59ff0672be1fc623"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea318496463db9df3bc9b6127106eaff5db0545f874ee354c5a28371364cf17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b5d030d9688c469f7f5eac4bfa9bdba964276696118c9d1fc4bb5c49567ac00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6acc1ca5a775aad7990fa5739936afefe1081d1c9a311006e1e8b17a5e09badc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a5c6f40b7b4664d4c5d5d4a41f576f7b8f950c169e8554f9ba398d12518a73e"
    sha256 cellar: :any_skip_relocation, ventura:       "34545a775fcfd80dbeb2be09f09d7fa27c4f1306b82484c1793f7430427e778a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a15ef3b120ca7e00647f806bc52b4f57c609dc6aad6ad909ad47f3493cea9659"
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