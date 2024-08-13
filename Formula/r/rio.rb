class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.6.tar.gz"
  sha256 "24f7e11a625a7926644d5682f382673c7000d7dc48d0e2bb238d45ccb5d54cd4"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7f0b2e98858205a0e6ce9deb803ad86dfe85d7ad8602b8d36f99b7f1de9bcbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cc3264dbb2b1065634d5d8ac7ba68fe24faf0da7bc458a7dc298f74687d2b90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47bf76dfe9938d232e9fe8bf0e45d431b013907525c177ee744deb854498dd4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a03035949f116c1b5f1492185a0074b117b77e490b5e57d8a6660248d658a3fa"
    sha256 cellar: :any_skip_relocation, ventura:        "ccc0c5bf36e8a86e5389fd5278b5fefd8012cf073f7dc510b6f06340a11e95c3"
    sha256 cellar: :any_skip_relocation, monterey:       "c03866fa1c651a9c8aaa69b92dad12ae5a113654fd43e21170295ec5acfab116"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontendsrioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin"rio", "-e", "touch", testpath"testfile"
    assert_predicate testpath"testfile", :exist?
  end
end