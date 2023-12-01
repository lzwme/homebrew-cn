class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghproxy.com/https://github.com/raphamorim/rio/archive/refs/tags/v0.0.28.tar.gz"
  sha256 "9883320942e83994fd6ee3e2272ec811d99677fa59f3c8ccd0437735d74d0dec"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c2641a03efb37c0a773606a3250ba9a315302d3492ce764d1ab2bc90e85acba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf068b0d264996dcca5a41553286e19bf5426c7ee0cfe24df3ac75b03264bc9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "127a771d3ff168920f00702160011932d47073255ccc3e66125e88721a1ccdac"
    sha256 cellar: :any_skip_relocation, sonoma:         "6090ca7f15f0d6cee94ba4b6c839ee0eb0a5dd792b31adfa2e7807970598dd9f"
    sha256 cellar: :any_skip_relocation, ventura:        "f6486bb3078aea5a63e0343a0a8b5fd609766423ef74907c79f3809120688acb"
    sha256 cellar: :any_skip_relocation, monterey:       "541492b2627c71ef4bbd4fa653d39e10a791db4d5a3c1c06b03d5b6744b8d69e"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/cross-winit")
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