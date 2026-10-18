class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-36.0.2.tgz"
  sha256 "eb910e5199cc4ec9ef02342099c1dbfa2b2781a6a59c62bd5f0ef9f9c59b4d68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c348a0460ded0459be7c3f93e25fa3ac2534ab992f829a799f16a1247674919"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c348a0460ded0459be7c3f93e25fa3ac2534ab992f829a799f16a1247674919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c348a0460ded0459be7c3f93e25fa3ac2534ab992f829a799f16a1247674919"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7cf32bda801304a080d3077aad3ca741c839c3c789db0bc2d6c27e51c4d56fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7cf32bda801304a080d3077aad3ca741c839c3c789db0bc2d6c27e51c4d56fb7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end