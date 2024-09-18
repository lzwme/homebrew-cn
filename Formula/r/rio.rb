class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.14.tar.gz"
  sha256 "9013fdcd65ec64285adb83d18c18310a1e52e37f16183dec47e2fa62d862f2d8"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b86070fb3e189973a4adf9dae239b50177c11fc84c1c70ea9e01eb963d6da002"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdce8bf36e3ca7edbc68c44667d01ec8b4c31d795a94889b07d6a927000dea87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f47d1579022d6f786d447672df347d7b5824480c09a4c5d43693bf06e0a8804"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9f7fb3882ea778de5bfbfe481c12f24e83f4d693891e61ead7ba1b97771ec41"
    sha256 cellar: :any_skip_relocation, ventura:       "5764d6ce8c4389789c34aa70177a64db3eb3affa62088a454c35130cab701168"
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