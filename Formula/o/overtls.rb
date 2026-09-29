class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://ghfast.top/https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "112ccc0ebed42d962dc6bb061dd9da7663cd453eb826dbb9fccc56c890ac0679"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8fa8f82919a6b051c2eb74d7cda84428592d54c4abcfe8e9346622be5ee55ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d71ef26278d41f4a7ea69a9f4f4b119bf3c96bc3150f35b9c047f4379531ab6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6158aad9356199038ad59ea37962b5544896ae01455ec6569d142f7fb1cf2b63"
    sha256 cellar: :any,                 arm64_linux:       "6b79654baf2151cbca02c7c2b5b14c992354ee9d0af90becbd0157ba185fbb0c"
    sha256 cellar: :any,                 x86_64_linux:      "c7812620d6127d283e1618b7bbd145915c1bd2cc541481cb75fbe490dc71d724"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end