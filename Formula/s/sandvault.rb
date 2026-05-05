class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "b40664e92d16c4b7b4c18be208863bd252060fe4cf3a948f77edfa3e503c6bb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc91f02c8a01000c2a9bce901e1f17401d8501b90ce5f0ca09705a221875cde4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc91f02c8a01000c2a9bce901e1f17401d8501b90ce5f0ca09705a221875cde4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc91f02c8a01000c2a9bce901e1f17401d8501b90ce5f0ca09705a221875cde4"
    sha256 cellar: :any_skip_relocation, sonoma:        "790bfcbf033449d8701b77c8d4f3fbbc87f546eb0cc4c8df6059a85e8e89a37a"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end