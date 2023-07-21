class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghproxy.com/https://github.com/raphamorim/rio/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "59f429027d60177bbaf1b6190413f2423d48d9a76e8f4ad906733cb83fb6fa07"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9796f9aa22fb6bb16e9edd958531d1766b87086735fa200d87f3ef0a064c3894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "716fa7daaaff76ecb35dde62a56da99550ceefd338c8087c3fdb0a5a890b5116"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aaeac6736a5af3d6032cbf77154172b77a95c399679f60f03d2133de7fe650e5"
    sha256 cellar: :any_skip_relocation, ventura:        "3bc3293fa15f3e198eaea791429d7c1d68b120e9e2f101efa87b362db2a2d507"
    sha256 cellar: :any_skip_relocation, monterey:       "253fa06b0a1725096e5163b12423069a860b757d9ce5c927d4c62c9860ea6f36"
    sha256 cellar: :any_skip_relocation, big_sur:        "26166a1347cd2b8090a561c6f8863acd4bfa5cbf60ab0902bd88770769afb546"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "rio")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end