class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3440200.zip"
  version "3.44.2"
  sha256 "73187473feb74509357e8fa6cb9fd67153b2d010d00aeb2fddb6ceeb18abaf27"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9aab609d1e9c7163aa0ff6f1907424e35f6d0bd169c3bf66d4914f25713a7772"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2666d399cc97c15db9dfff049e7f14e936615f077850ba05f94ac7c020d2a60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0e838b892dea423e04fbb12f4fb733c8e4713526858dc5c5aa44e9815a2f350"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd9e8336a168425cb55b0dca0681905a41319494f7db3eb62779f13d332b50dd"
    sha256 cellar: :any_skip_relocation, ventura:        "0e1363b69a35152328683dacec92fd5e790082a1f5ef64105b2e76c6cc271d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "993324321f9b7c1cd0b0e6c688c947a3c23583dc5e5ed6a127e8391377ca7e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91648f0de8f8f0834e4781f60a7c3cd7c5eb6d11e3cf38f05e5964c35f622f11"
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