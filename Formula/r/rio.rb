class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.2.1.tar.gz"
  sha256 "4aa1a7e5860d30fd629edd18aee8b548e92ff264ca9a755f3e904d0422b60be4"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "366acf278d2f1f4c3c50039ce4865ac09dc7dca8100172775256e2ee6d171da1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f2ff0d4997f63c40f156f34b4226306b653bdb9099550c3510e36fb4a55ad6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ed6aa07113c2e1c0f0344fcd6f018163a0c83580f62aeb07e073fb5fec464fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e81d2d25e2951b825823a97676ebb624dc038ebd111df4cc331d11ed3c3e4ed"
    sha256 cellar: :any_skip_relocation, ventura:       "ba8c4c20aef25d5ff82293704302328075f7ce3d9fc1f9a6f674ebb6bc07cd1c"
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