class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://www.mongodb.com/try/download/shell"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.14.1.tgz"
  sha256 "0e9925bfe8a146704c1dc169223f4f69b3ea5e17c59e7cd1fefc58eb2e3e2158"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "afc2846c02b3eacba117bfb485522a36c6d0e88a5562f81f78508089261a132d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "afc2846c02b3eacba117bfb485522a36c6d0e88a5562f81f78508089261a132d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "afc2846c02b3eacba117bfb485522a36c6d0e88a5562f81f78508089261a132d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9ed187e17bca312689b320beb580b7934526aefd5a7974eb99cf1e12916146a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b9ed187e17bca312689b320beb580b7934526aefd5a7974eb99cf1e12916146a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end