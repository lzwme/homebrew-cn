class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f14e091a84d29ca3875e0981388ffa9a9c03e00c8165bad6e1eb2e4281c13300"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39d9f456d6a6e49d0473fd53ce4d2a95495cf12a2170526a3dce3636b035905c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39d9f456d6a6e49d0473fd53ce4d2a95495cf12a2170526a3dce3636b035905c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d9f456d6a6e49d0473fd53ce4d2a95495cf12a2170526a3dce3636b035905c"
    sha256 cellar: :any_skip_relocation, sonoma:        "19ec6874af3729a6040e47373b1089a9f80e6d9428cbe908e2dd8f1b38198be4"
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