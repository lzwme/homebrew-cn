class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "1405d9b6566ee4c9305880cddcb6e1c28e9ca150124bd9f7d1c535832abacd1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97e48db22dd682a27a097b300b94df5b8aa6d83a4c25d23f3c34f244abcdff10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97e48db22dd682a27a097b300b94df5b8aa6d83a4c25d23f3c34f244abcdff10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97e48db22dd682a27a097b300b94df5b8aa6d83a4c25d23f3c34f244abcdff10"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dfcf096bfda9f72e314fcdcc85b4e82cd9b73706b2b2c1ac82ac7793bb91f8a"
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