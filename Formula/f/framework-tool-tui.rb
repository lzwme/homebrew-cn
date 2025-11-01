class FrameworkToolTui < Formula
  desc "TUI for controlling and monitoring Framework Computers hardware"
  homepage "https://github.com/grouzen/framework-tool-tui"
  url "https://ghfast.top/https://github.com/grouzen/framework-tool-tui/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "bc7e2544de0e400b9a432778d4ad68d908f93d9663886496f4f48ae9f24c57bb"
  license "MIT"
  head "https://github.com/grouzen/framework-tool-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "62b235653ef049ed554ca7314b7cb5b6d242000593b47d4c75a4128677769643"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on arch: :x86_64
  depends_on :linux
  depends_on "systemd" # for libudev

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # framework-tool-tui is a TUI application
    assert_match "The application needs to be run with root privileges",
      shell_output("#{bin}/framework-tool-tui 2>&1", 1)
  end
end