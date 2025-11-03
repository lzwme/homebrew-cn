class FrameworkToolTui < Formula
  desc "TUI for controlling and monitoring Framework Computers hardware"
  homepage "https://github.com/grouzen/framework-tool-tui"
  url "https://ghfast.top/https://github.com/grouzen/framework-tool-tui/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "cc97341ba72dcf3aeedfce7435c2e72be198bceef9ce97231f3d5c0743c00800"
  license "MIT"
  head "https://github.com/grouzen/framework-tool-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2c5b1d6098b0fd14e372a981bdc5d495b7db329dd62b68ef2d48bb28a2db3141"
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