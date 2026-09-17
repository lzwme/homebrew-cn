class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://www.mongodb.com/try/download/shell"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.11.1.tgz"
  sha256 "b96f34e2c010ad1b7ce864664bd92a099219d56ecb48b8c9a70d77f8b86d1202"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e673266b83ffd9769f62126d782982e4015daef1e8d51972ab57f6d7bbc9520"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e673266b83ffd9769f62126d782982e4015daef1e8d51972ab57f6d7bbc9520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e673266b83ffd9769f62126d782982e4015daef1e8d51972ab57f6d7bbc9520"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6c915eead76d12cfcc8a734a5c67145286768e8e37f6033061d0f3c7d9f5e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f6c915eead76d12cfcc8a734a5c67145286768e8e37f6033061d0f3c7d9f5e0d"
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