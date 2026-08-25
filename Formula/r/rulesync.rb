class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.15.0.tgz"
  sha256 "118d7dfe22f19590128a60d07e43f20c0a7540ef8d31249746c790aaecdd9f62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dea5155f4f8bd65fde314540a1306e0282d0f9156c12c0cb20e183c9c98c349e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dea5155f4f8bd65fde314540a1306e0282d0f9156c12c0cb20e183c9c98c349e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dea5155f4f8bd65fde314540a1306e0282d0f9156c12c0cb20e183c9c98c349e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d810b8ca7b12e69108a04c708c3fe47e054cc4c9a063f875c9c6429fa33a968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d810b8ca7b12e69108a04c708c3fe47e054cc4c9a063f875c9c6429fa33a968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d810b8ca7b12e69108a04c708c3fe47e054cc4c9a063f875c9c6429fa33a968"
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