class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.12.0.tgz"
  sha256 "8510c005452485ca428002eab8732e85add26be9b31625639bc47ee039d55d54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a64bbf0a66332700ec8a24ae296233c2d8d1e4a5a6c3011ef75c116ac0bee496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a64bbf0a66332700ec8a24ae296233c2d8d1e4a5a6c3011ef75c116ac0bee496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a64bbf0a66332700ec8a24ae296233c2d8d1e4a5a6c3011ef75c116ac0bee496"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8bb2498af44a5cafe7f8eebb6cb6265a288bf58883846af3d7623769061c913"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8bb2498af44a5cafe7f8eebb6cb6265a288bf58883846af3d7623769061c913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8bb2498af44a5cafe7f8eebb6cb6265a288bf58883846af3d7623769061c913"
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