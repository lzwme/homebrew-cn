class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://ghfast.top/https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "4421f83ad8f89374350a1a98dc8428e9ae97d0eb68dafad799212d52a3cb6db9"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66ada01d23cf0a2c5026eb4e7b4de22a86d9688b7556b82db81d780b1df25601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c7337ed46658bf84c4b03ff37ae79b609abf44af425967c55c9938f9ad5947"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b43f206baa79739662e99559ff590a34611a5c74f64bf077950337cff5d7efc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b693ef94ff8e5bad4442c6bf84a74f2c9ae0f1e007f8b438a1385402c8522847"
    sha256 cellar: :any_skip_relocation, ventura:       "4131edf9d29cb2e47763734c4fa184baff85bca8693475fc65162e577fd7d3da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14eed7f6755a10b90790086fbd52add90ccc9d640bb42a518937bc7f7369fb47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a08d28fd2cd73d3955bdf5c1596e61561de3ad3f6d9a30996b9a45c0d248e36"
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