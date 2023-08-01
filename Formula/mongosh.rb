require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.10.3.tgz"
  sha256 "824d01bb6eb5ab4c48431512b28d135041b113710065d15994e3acc1d1abe633"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "8edc12aa7c792ca38eff7a143408b4a58dcff43ae7aeb5b575b66c990aeb7cef"
    sha256                               arm64_monterey: "6a864e921fd83e1f90c53c78e2c368ff20ffb499c2789fa67051fcc6a257bf71"
    sha256                               arm64_big_sur:  "45ed9d8342ae79175bcae96ffdca8e2e34bf1dba76206288a0d2ce4c0c969948"
    sha256                               ventura:        "0c0c1e073b18ff5bbc78c93ff52f861a51125968665d04d3a3fbb5543e636fab"
    sha256                               monterey:       "db95f8b65a6e36a76c9bd5528c0054a63f2babb03d9b29910e9595814756ac03"
    sha256                               big_sur:        "bae55292edf01fc2eca5d8d5eca1ae2b8438f717882de5d8154666bb2ca048ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b816e9eb37212416e3ea096216b9233dbce07b981f347f5b225feb697c472c8"
  end

  depends_on "node@16" # try `node` after https://jira.mongodb.org/browse/MONGOSH-1391

  def install
    system "#{Formula["node@16"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@16"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end