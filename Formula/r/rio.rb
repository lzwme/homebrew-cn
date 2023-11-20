class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghproxy.com/https://github.com/raphamorim/rio/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "2338d679eaec987bd50ab12ca1e9b79853690899d2e8e70efa88315d0c626090"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7527bca70e078d61791f592c74b4908148f23fd3f064a9b8ccc10ef4c4cf0358"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f45254413b96fa0f532092ca33372924b4151790bbc63256ebdd8f26f277e70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c09955a7e70b221b8f7811bafecd602827f0f02e1fd9c419f9137bd53e0ac3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e420240be18fb1ecb0a5ead30407a4792e2c32b783baf0c3e33983a91f82d1a3"
    sha256 cellar: :any_skip_relocation, ventura:        "37c8a463712fc70c6481b1a464d287538b7882288da2dce1bf32b594b8c61f79"
    sha256 cellar: :any_skip_relocation, monterey:       "c59c806b7a5bdfb1f35e8a3e82ffb369b41e5425a0255bb6a810f0fa9e3ea8f1"
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