class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with live telemetry and leak guarding"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://ghfast.top/https://github.com/Harry-kp/vortix/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "65d7ba9be74d538833113c488fb9a94aad1f11413ccdf0fc3087dd8bfe835125"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5956a47f3219515b63884b15d9df7055215b67df8f8593a90165d01e8a5a8280"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c2bdbf422bb540569a3dee6584375a22e9e4324c4fd8a80c30fea2baa46f889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f4fe8e2b9605abb110cb4c8503744c02e7f90541cbd39e236870858ff7dcab10"
    sha256 cellar: :any,                 arm64_linux:       "170151d05899ebbeec21ec3eb7618839da604c6ab89e8f48adca84f8334b27ef"
    sha256 cellar: :any,                 x86_64_linux:      "78f83bb37c551a286b1803b3a8b562616f6f65bdbcbba66cfd26d26e53ad162c"
  end

  depends_on "rust" => :build
  depends_on "openvpn"
  depends_on "wireguard-tools"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/vortix")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vortix --version")
    # Mode names are checked before the root check, so this runs unprivileged.
    assert_match "off, block-on-drop, vpn-only", shell_output("#{bin}/vortix killswitch auto 2>&1", 1)
  end
end