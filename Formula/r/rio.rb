class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.0.39.tar.gz"
  sha256 "493b63ba87b97af35c2822e3008c793890e3887c439d30b2d4c556058094041e"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e81ebd431a8bbb27019c5b518c7027f8105a40aa91d0599eeec5a6ef8cb7d3c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d62cc74ff88fd1d9c658a071b0a17c048111f4b5bd688293a4cbe24e28b60223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e63e0cbf45f2c50e378cfb5250bae54f6ad828c21cb52939e1fec20ee65177b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca74305c61464fd34440ad193d228a2a3244a0ac3a1c033ce2d1af237e2d5cb0"
    sha256 cellar: :any_skip_relocation, ventura:        "be24d288bbffa89b7cce6618d48e3a1fe7e4e86654d61628d5da6d4a088a6830"
    sha256 cellar: :any_skip_relocation, monterey:       "c76a4c0a04eca46f962191722066440aad05e3967b86af826a141f52491494b9"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontendscross-winit")
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