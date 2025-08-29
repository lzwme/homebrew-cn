class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.5.7.tgz"
  sha256 "f4c5fc407f29e104071b1921afb13631a58828891b670b9c5e1fbfa10e4e4b3f"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_sequoia: "73d3854e661835a0ba37821986068c9be0ee3f75ae159b1c53affaffa72b8d0c"
    sha256                               arm64_sonoma:  "7d5e1818e9719c1e0c0e593695c19ab0cb736481e805cdec4371b9dd163488a0"
    sha256                               arm64_ventura: "18a6c9b3bae6b3e145d1af76d5d2b88b17cf43cce91eb0a16e30cf56b0158c85"
    sha256                               sonoma:        "2c6629a020e25612928e5702dd9d507afab9097123a9d0b4369598a7f4201a95"
    sha256                               ventura:       "523a3af19b30ee32fea4df0023d7b19ae930ec68501dce27a6161263de3afd3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d0cce39aa0642acbb0b55135c6b9286c4876b70f2ed5de75258e28963b6e125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21d4a311bbbe5e9b74ad77d363ec9f7adeeb4ab2ba07b5b32a9df3cbdcb07004"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end