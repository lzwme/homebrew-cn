class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://www.mongodb.com/try/download/shell"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.14.0.tgz"
  sha256 "bbb74f8349324fe178b62e0920c4c8f4715496596a6f97aee1772f56a25a7620"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be68c5419310a5265a7bcc8afd663d9f2b93a504bd20b0da311c86972d82924f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be68c5419310a5265a7bcc8afd663d9f2b93a504bd20b0da311c86972d82924f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be68c5419310a5265a7bcc8afd663d9f2b93a504bd20b0da311c86972d82924f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d7fcaa1d91e3f95e6b73b0907dcbd9376a8998379967df68cecbdf11442f4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6d7fcaa1d91e3f95e6b73b0907dcbd9376a8998379967df68cecbdf11442f4f1"
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