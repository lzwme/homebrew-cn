class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.9.1.tgz"
  sha256 "8a12dc2b1ac49111ff69e46a230a6d0a718d7f44c2e12ae11915c9551864311b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbdf22887061fc57a3305e7c3dcb4998e7946f4f1a5efbd23ccb1ba7e713326b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbdf22887061fc57a3305e7c3dcb4998e7946f4f1a5efbd23ccb1ba7e713326b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbdf22887061fc57a3305e7c3dcb4998e7946f4f1a5efbd23ccb1ba7e713326b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2402b90ac1b035af2f517ca7f8599e3316869ddb776b2c524188240abe6d6245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2402b90ac1b035af2f517ca7f8599e3316869ddb776b2c524188240abe6d6245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2402b90ac1b035af2f517ca7f8599e3316869ddb776b2c524188240abe6d6245"
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