class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.32.tar.gz"
  sha256 "dd2993fd9174382abff53a71c18aa6e991a2e9bb83b6c49ff0d53af6624bd18f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "807052ddb61cef3de7024ad74eb36dc1b5fe31fd843ef9f31cd026f80e1c0d02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "807052ddb61cef3de7024ad74eb36dc1b5fe31fd843ef9f31cd026f80e1c0d02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "807052ddb61cef3de7024ad74eb36dc1b5fe31fd843ef9f31cd026f80e1c0d02"
    sha256 cellar: :any_skip_relocation, sonoma:        "045ae085e04fb289157cac2545d966ca45ec3af26e12a5834e216942731ec3fa"
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