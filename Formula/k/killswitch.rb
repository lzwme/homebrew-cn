class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://vpn-kill-switch.com"
  url "https://ghproxy.com/https://github.com/vpn-kill-switch/killswitch/archive/v0.7.2.tar.gz"
  sha256 "21b5f755fd5f23f9785bab6815f83056b0291ea9200706debd490a69aa565558"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6046e0651dbe643a18f990226484960f38a73a0e5c6e8dcc13f8d7f0a0304801"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e8274a56bcdefb89eec6aa37d881866e77833f8e29291066adcfc55a7436088"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73d4c8aa15e1aa363089be53bc11fb347994c1144ad35a65d01584727f74082d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf8c995419a923e0512fd5e2d54a88d46719e157f1f9592ec82289e97f3da876"
    sha256 cellar: :any_skip_relocation, sonoma:         "c562a7bf378042372d2cc9227db029779db7077e64ffce9880564978b33b2812"
    sha256 cellar: :any_skip_relocation, ventura:        "894d0603001920b3ac4f419cb730b52e3b273ba4d0cd38a5f318e86fb4c3d577"
    sha256 cellar: :any_skip_relocation, monterey:       "aaddf26597e4de2554dfc11bb909615a612e0389774cea37f4356432a666bb41"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d3e4381fb6137e38fd394941e40f1c0fab743c7b4bfef3c2ecb43679b6ab03b"
    sha256 cellar: :any_skip_relocation, catalina:       "3e00a8591a897509a48c65d76e529c6f4ef6fc910ebb762c8e5e7f54e2e03a43"
    sha256 cellar: :any_skip_relocation, mojave:         "4cdbf573342205befe4e908ae318125be61850d2346c5ca649cdd867067eab63"
    sha256 cellar: :any_skip_relocation, high_sierra:    "82a98dbef512e928dfcee02d0c7c50889856ce88740645ec1af0fcac7edfab12"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w -X main.version=#{version}"),
           "cmd/killswitch/main.go"
  end

  test do
    assert_match "No VPN interface found", shell_output("#{bin}/killswitch 2>&1", 1)
  end
end