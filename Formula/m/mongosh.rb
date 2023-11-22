require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.1.0.tgz"
  sha256 "a2b6e5328a9d8f4b7c8df6881f3b7f8e96c26f537a313d1b0a35714688c480a3"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "18c579b4083edcc9ef99cf34f263fbf784cf068404cfe55d041e5ef9bd76a7eb"
    sha256                               arm64_ventura:  "d905967aed7854c20ca545ebd3ef48ed542d6c002ad9753e26fe4118a27c1094"
    sha256                               arm64_monterey: "033a4a665e489e50e7a9fcc1e81db192e4ed1e0d31f41647badc5b3fb4a6ba92"
    sha256                               sonoma:         "3938e735878611d99f53aca193d5395d909c15612e74eec4ad8a052640efab42"
    sha256                               ventura:        "b75f5f4b3cabb2e454ed2ec63319c0f7cc54025f348b89d1569240c9bd666d80"
    sha256                               monterey:       "5db2cb603f8d8e76843954aa2c81035b5e709d3d073a13aef1d16d268e4b56f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c33631e0b4c4701082ea353c10019895c9c6480a2860a2273b8d939a22e34d2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end