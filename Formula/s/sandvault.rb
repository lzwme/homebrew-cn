class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "90a4b3743ec33c014282d1aef250338e2f4b9bdefaefbc6cf3e27b0a64be6225"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29f93aa53300d52f5405ecba083c250e4a795eb0bec5391bb0be5a19860c42aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29f93aa53300d52f5405ecba083c250e4a795eb0bec5391bb0be5a19860c42aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f93aa53300d52f5405ecba083c250e4a795eb0bec5391bb0be5a19860c42aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "6436c74191dc4eed407ac0aa97d53b60101567cd49739e26b6fc3a5e342bf9e9"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end