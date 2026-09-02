class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.19.0.tgz"
  sha256 "143cca2621e480e596c4b97aeda25fb878856a5a5dc280f1f4aa98d167208c1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fb7d7b03fef2929ad6487e959a5395c0159dd46ff755c095733a3ba77337079"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fb7d7b03fef2929ad6487e959a5395c0159dd46ff755c095733a3ba77337079"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fb7d7b03fef2929ad6487e959a5395c0159dd46ff755c095733a3ba77337079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72568cee1aab276ec0223b97fb980ab1943b74d0fd119a061a0b623155070d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72568cee1aab276ec0223b97fb980ab1943b74d0fd119a061a0b623155070d07"
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