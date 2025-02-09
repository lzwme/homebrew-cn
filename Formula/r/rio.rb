class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.2.6.tar.gz"
  sha256 "142846ebc16b9b9fa2adaa261211a9dcbb4329d865b9fd0215e8c11e8b1e891c"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bda97bd5d240a359ccb48b88a443c82de81bb9ebe0558f6675f8ec73a7e9fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3b73d91b209a8d244af264aa5c9ebc5f430183e7b8504a00662e13ab887865"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7c0c932ff83e20b050e1fbc364eeddfec0018aeb5c546ac0c671a5203163ebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d8989650c679d31d0de94ae8a43800f198887a900a1db91200f11eb967ebe6c"
    sha256 cellar: :any_skip_relocation, ventura:       "3027b51d2e0ec212cb3454ce5ef40e67f944a9089a9e24a5c6162504a5391615"
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