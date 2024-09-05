class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.11.tar.gz"
  sha256 "13195ed732c74320c2fadffb1beadbc1ade44043a0544b00dec54c0c613426c3"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d74b1003b5c52e129dd76a1353e18140559bb3bb1eed293934062f111a7f4986"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e6a53d163375b1e4921dfda336566cdf0e7a3aec35ec41412d68b3d703c4aa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d14e9d477220809e5314400b7563ad81e304df9ea67f92001e8798ecd3a8e54f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9229516472acd0f8df9f6ded6f9453a34b46839c4d4a15f54ca8e81b897ead2f"
    sha256 cellar: :any_skip_relocation, ventura:        "fc069e34ee879d3492eb26565092ae863592fc62a0775cb2d5e7229a1cfd58dc"
    sha256 cellar: :any_skip_relocation, monterey:       "b1fc26b1bab9872100a6a2340d706dfc2690078efc7d1a1e47d86e34015e59a6"
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