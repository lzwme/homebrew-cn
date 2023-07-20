class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghproxy.com/https://github.com/raphamorim/rio/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "a0f7bfa118cb35cb5ea5b7a9f0b16ab379d9ef2d3f58ea6f83e77c02341084f3"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3461c8cdd916acfd870e8073d485525532796ba259afc35dd3c99812472b4197"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "894e570f34ab70eaffa182512dd9724d3bdfe3b53d441079332d8b79992d7359"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a01813df298e457e13abc770b25b821d5351364348b4c2ca723b546d530a888"
    sha256 cellar: :any_skip_relocation, ventura:        "8d9fe49b027b621da60769321023e404843f80adb9a9fcadea77ee5bce9f7d90"
    sha256 cellar: :any_skip_relocation, monterey:       "16ebc24e764c6b88cbe123edada3cc3b4110bd9ea80284e832d98e5eff350637"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f8984958b8d7f237768e7769210f5e61d8796990f60850e8499f6bf0254d497"
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