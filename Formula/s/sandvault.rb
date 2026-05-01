class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "0892c5fc1dfdbbe2bcdfb0f212089937abe319fbf349e4c49b48fbfb10f84c67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dacac9aa178d413d2da1c1946bf9768eaae841c2da42a16e588ea412c8885dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dacac9aa178d413d2da1c1946bf9768eaae841c2da42a16e588ea412c8885dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dacac9aa178d413d2da1c1946bf9768eaae841c2da42a16e588ea412c8885dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf41d9c853079864f1adf1559117dbc4753ee5323fec66e86425c327d5f4a33"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv", "sv-clone"
    bin.write_exec_script prefix/"sv", prefix/"sv-clone"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end