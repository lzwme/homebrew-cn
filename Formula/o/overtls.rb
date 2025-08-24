class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://ghfast.top/https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "fee6f8b5c134795ef2a64eb2a2591284b5a6923ef85bb422fe1baeec057f53c8"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2e59b18757a215fbab5b638d7bd1e00d446866b939225fdf77ee8ae402da713"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae671c9fda6dec4c480445dbbef564bc31c3a17317c5ded94f4ea165274994b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a93f7815c8a244da8ee0c25ebca5407151357b2063304edce20368c5d7d333fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "85d1a57b1605cf7019d3b34babc85e0c86f35cedef6ed33d918e29b09e567dae"
    sha256 cellar: :any_skip_relocation, ventura:       "d96c18a7c2b0fdc540461f7f91ec11b3c5dcd788f0291cf3b4c3155d137a6416"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad408a903ce58de63d605d837cae5796c32bd0238fe2b0df0e50677fc2f2b522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84004c95e5cc7988de0dcd8653f87cc28aab6ecef047d28f307821d18c40569c"
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