class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "32263748414585c1c639e31925c1371f1eff5a04d65c9302a7f3251c03667f54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "338006d285840288c1689647da2fdbaa998438f4bb84bbe51b7365ed24b66556"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  deny_network_access!

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end