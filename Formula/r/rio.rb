class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.5.tar.gz"
  sha256 "58e1a4a3b8a97ca7234634f71586db8b6d061e22a76f8b4cc620b53a9be114c6"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f63ce591ebb39a3985914d1538ce24016b0a00c116572be27e3902bafa9211f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72b5b7b599e425dfe722dbb1d5407002bbf900df9be2b9be110cc4fcd13b9d65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f43f3ef9b46a8475c6ec19009e35b9dbb6cb9ecf108271299076d16ca62bf54"
    sha256 cellar: :any_skip_relocation, sonoma:         "f19ee2d842fc9e4218416fdf7dcb13757d1d475932662a5e96ff09c09003d208"
    sha256 cellar: :any_skip_relocation, ventura:        "084a85406f979f443ba5d6204018073ff21d0ffd805e310ea405156a27b02e09"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ca60639eb770d74ea634568ddb30246fc0b5229cb410048617fc366b108bf3"
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