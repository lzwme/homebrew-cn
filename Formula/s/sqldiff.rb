class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3440000.zip"
  version "3.44.0"
  sha256 "ab9aae38a11b931f35d8d1c6d62826d215579892e6ffbf89f20bdce106a9c8c5"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68d713cb49c4533e0f4200673a870e122f869f47e9913888f0f8c4e2d173b5fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f14f44ed9441c8e6429906db3fdeaa01685160e24dc64ca1c35eccd815cfc1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f6fbb85e03b3867b53bb517ce4a1225e96cea74ce9a1cfd9f75761dbd1b5d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "08366795fbe94cbba3d10e49f85702c36bcb17616ca9989db34f120efb1ca661"
    sha256 cellar: :any_skip_relocation, ventura:        "6e74f9e350efc0ffadac71afe99d5fa4f0ec8777044f608eb7b30ca8bf3c4fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "da237ac03a354deb9636d4d51f7153949f733f208c04daf68cc53d4812f7dc3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08986a97427a83bdd662d095a6b2c23064b116d4d943088d1e683dcc6f0f4a8a"
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