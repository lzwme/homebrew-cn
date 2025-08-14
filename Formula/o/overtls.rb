class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://ghfast.top/https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "45a017e3bd233b3ed09751bc7f94db8cf1685cb906c7f5181a478e879c543047"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f83757fd08e879dd32c1c76a85d338161f58ea2929af14b885b372ae1aa88a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4bc726e8880ea6bdb5b93c0708a0b16bf5a92019ea2b303bc91913e9acec49b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b5275603ce0c6a7fe29fd5da3136bc0a0fa1e2e92608a42057a24f276ece31f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b713c182fe9c672cd1a48d49fea25e400d95a9b54d2d65f7a8d5e2864ccf2b2"
    sha256 cellar: :any_skip_relocation, ventura:       "e17cf0e2070fe6f3788d20ba40007f75d0c40e9a42574fe7f164f31417dfe99a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d30625502d0b22cb12f562ba9b887c9ea036fa121277be20e8ca7232f0b14509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ac419fca931dff8535931b7b6bc4e7a9a1aac6365b1d18240ea95053d8bd41"
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