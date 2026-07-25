class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.267.tgz"
  sha256 "4a9a7883976b2d3a1cd943f3754d7b1fde9cefbac2bdd7c1bb04b9364367b79e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70b529a9cd22c7d2541279ac3540c326875cc698f9983cbbeccfb394fbad76e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70b529a9cd22c7d2541279ac3540c326875cc698f9983cbbeccfb394fbad76e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b529a9cd22c7d2541279ac3540c326875cc698f9983cbbeccfb394fbad76e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b92cf61d12060f8ada9e53068a847315232bd01e2deaecc415ac5e566f3d973"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1f39270ff71903c8b625f62beb0d8b312b77cbd20dde0b8fc72671bc842d53e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e3a69645b157aca3bc35b09e006d47d440c9cb013ce5157334ca3f1361430f"
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