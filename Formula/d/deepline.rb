class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.400.tgz"
  sha256 "e9abcf7c73b56922a8d64dee59d1c4a4b2d4cee84fe398e83e7cf20dd32330f4"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7306c2175d89ff00fb938ab9194b91a053e2b9e993af082bf180d8d082538bf3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7306c2175d89ff00fb938ab9194b91a053e2b9e993af082bf180d8d082538bf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7306c2175d89ff00fb938ab9194b91a053e2b9e993af082bf180d8d082538bf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d37eec4a59f59a15b551903da015f5dd5311eadbcda53d13534cb23753941a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ec08615b697f1351929ffe24927e79d51bcc626fffc416a1e7aea3050b0ab3ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder --json")
  end
end