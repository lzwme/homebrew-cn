class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.21.0.tgz"
  sha256 "2992d983f5a78789590b2791b5a1eccffe9cea972126297aeb245c18c74a2c52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f210602d4162f5a95cc2e7bb61cbfd5db484a678596b9eb45173975a887dca6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f210602d4162f5a95cc2e7bb61cbfd5db484a678596b9eb45173975a887dca6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f210602d4162f5a95cc2e7bb61cbfd5db484a678596b9eb45173975a887dca6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbca5e2771d54b299d0abb88941e931961b4edde0868ba91af2db683061b00c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbca5e2771d54b299d0abb88941e931961b4edde0868ba91af2db683061b00c1"
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