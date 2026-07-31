class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "9bd42327fe4f1e42bf3d0650041bb6442c9765b651a39ae3f7725ff8c9a006e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "957a5c585494519516eb6b9aa0fd1c688a0c7ecdecfc789af89fbe950ca2996d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "957a5c585494519516eb6b9aa0fd1c688a0c7ecdecfc789af89fbe950ca2996d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "957a5c585494519516eb6b9aa0fd1c688a0c7ecdecfc789af89fbe950ca2996d"
    sha256 cellar: :any_skip_relocation, sonoma:        "14f723dee497ced8f7b743d26b289275122293861d50c70f585b39035ba9c068"
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