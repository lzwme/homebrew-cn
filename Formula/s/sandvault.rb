class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "4f5752d78b5d1cbcd0157c504fd89dc0d40223997592e292a29753a0e5671dc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1224d00b66127d46c0c8d437bd640c7bd22a16f083a3a9df68bfc0e8b76cc6e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1224d00b66127d46c0c8d437bd640c7bd22a16f083a3a9df68bfc0e8b76cc6e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1224d00b66127d46c0c8d437bd640c7bd22a16f083a3a9df68bfc0e8b76cc6e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8880e0825b72c51ef01f00849c62416dc0e9f779f0bb7db21b72a6dccf455149"
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