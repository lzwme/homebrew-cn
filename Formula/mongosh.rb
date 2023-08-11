require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.10.4.tgz"
  sha256 "8046f5d0b210717c3a539d818d7292b3d88b08cfbe8b328c28f9abf6e3de0f24"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "69ab42f888d1c73eb375251fa9f089f93db39d66a858d24301ec1c4426b7e278"
    sha256                               arm64_monterey: "365c5e1a67e7a409e132b7bbd6608dfa3a089091ae488ec29c9d18f6070f6519"
    sha256                               arm64_big_sur:  "f278895e8e55c97a54a3efed23c73d484d378fc400cf43a232c5b95f0d7d3092"
    sha256                               ventura:        "8180607e1eb90a36c274b25de39dc1a1223ef3e759173d7b4dd8e13c16c31974"
    sha256                               monterey:       "b814abd74c5c8fe41073f0f105d85fa9db48d3832da49dc57aad36bceb6f881f"
    sha256                               big_sur:        "b567cd46146c86e74f523f437b152446733a655aa9757868f95c2b13125dd1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3fed1bf9809f70d95a168dc0c3070ef6e72409421ffc315309b5d6f01b01355"
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