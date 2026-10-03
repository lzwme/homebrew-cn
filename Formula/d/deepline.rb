class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.240.tgz"
  sha256 "d0b9dd2382ebf05839ed0e360dc00263b91b64c3413bfa52ae638933bb0ce7cf"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4dc0733347df7bd9339614f42490487e540301814e276c01e5444e50292a6177"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4dc0733347df7bd9339614f42490487e540301814e276c01e5444e50292a6177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4dc0733347df7bd9339614f42490487e540301814e276c01e5444e50292a6177"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2d440f9c918633ca3c2813405d581ac634eb17b9a9ea5619f9caecc758a44eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c1f42ffdea1120a6c6d03ae12bd9a985ddfd62c0b12e9e81fa84b917c98fa482"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end