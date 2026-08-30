class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "f3fe0e2a0f83bdcf08aee15ea90390f0924fc6e1369a1b40405f3af9c6bfa857"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27fc626a829b91f6abaf3bd092e13d9603293759a094a1bbee77552053dfe8d9"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end