class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3440000.zip"
  version "3.44.0"
  sha256 "ab9aae38a11b931f35d8d1c6d62826d215579892e6ffbf89f20bdce106a9c8c5"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b4763933bb2a8f2b330a516c605aba2da2099c30362173a84e212fcc7b19969"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dcb72f17550e8049a1dccb3608b5b57de8f26231cbf003553e8fd7ccfe9496d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c1f45c8811f5d98f864969013263173d0d35260a1ff366fc6f7d192163554cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4c9170ea2d0f523d9aa366a1cd82d9d6d527d2ed28e93326b0fd7abfe8a77a2"
    sha256 cellar: :any_skip_relocation, ventura:        "e6c927b31dcdd1c997cbe1adbc0f0812874dfa9c3fba3b08ea63f3f9499fed93"
    sha256 cellar: :any_skip_relocation, monterey:       "0b3104d11559b229f17d7028c7a7d9da2129f480adcb047d18a761bebc74bb74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "532902b7855ec21ed272b5b656d28388854118fe861f177f1677859043428216"
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