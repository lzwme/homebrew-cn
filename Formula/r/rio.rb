class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.13.tar.gz"
  sha256 "7baa5e76430e6ca62643691875eb20e66fe793cc260cc409fd63aa3e6d014299"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8820c10f88ef50ac04cd67aa9e1da3b17eb2edc7a779d064a42bcb0ac098c023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd14770c30af9bb7ffd11f0eda756203acebdaf14ab045bf77770b494000fdd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c7fb463990386de27fc6fe3dfd3d3387068e9dd58762e68f0d1546c1f1a1591"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45894280b6a3328d7216d10fa655bf3829dc6aeaa925fa784aaba9d551f45de1"
    sha256 cellar: :any_skip_relocation, sonoma:         "08d16841d8f91027c398d5d2a12af62a1be266fd88d5d57caf8b58834fdb9e81"
    sha256 cellar: :any_skip_relocation, ventura:        "a3a2b9385a03c9256f834ef078129b9dabe9c51b6dd5a6e93d5156b58702760f"
    sha256 cellar: :any_skip_relocation, monterey:       "3e99d82a4010905779c51f955ab1182511453dfbe1b7e85e4d0e4f76a8798933"
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