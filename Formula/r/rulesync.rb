class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.20.0.tgz"
  sha256 "6de4d37fb4a9c84fd598b926ebdf7926fab14cfa4261b7251a6c0165e5c6e82a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f1d1581c16c1c70faeae996ddbb27087c56856d92c048206f118b05a5355c21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f1d1581c16c1c70faeae996ddbb27087c56856d92c048206f118b05a5355c21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f1d1581c16c1c70faeae996ddbb27087c56856d92c048206f118b05a5355c21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41838c88404c06c1def72013f25e5f34bd47a3b6d006f20c011bb17e7f9c6c3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41838c88404c06c1def72013f25e5f34bd47a3b6d006f20c011bb17e7f9c6c3c"
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