class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0636982c7e117106d461aef93b2c56fdef80d3f82e9b745d1d91d22b6751e887"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4066c5e0c97fed128306b2960eddc13d20f56d435a5f2399eb2b0ace482620e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4066c5e0c97fed128306b2960eddc13d20f56d435a5f2399eb2b0ace482620e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4066c5e0c97fed128306b2960eddc13d20f56d435a5f2399eb2b0ace482620e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4982df5672db53761c2ab194d454ce0f75616b194c7ef98ae98e64872e114aad"
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