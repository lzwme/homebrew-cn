class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.23.tar.gz"
  sha256 "62d36296f3f53d573a9b34c8fa5da29882f7eb17c7d8abcd526245e0a33af9d0"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "525c6eef8be06c06c7484ad435542061f38ed79b3a9045dae568d3683a14b247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e989be4fbf13948e6745d045f675338e46cb6e75bcd608e2f8c1a50dd230949"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20b6cfdfdbcae205667b2772d518c0ee5019047acce3f46378fd52bdf1ae08f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "acc068d99fc030a30dea4f55c6ddd264bb3c4852aa1a92f040fe7fe5848638a5"
    sha256 cellar: :any_skip_relocation, ventura:       "de0105d0f1ce0d3167cd51a727eb8cda6595232f0a8cdacbc106d5eb782a4a66"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_path_exists testpath/"testfile"
  end
end