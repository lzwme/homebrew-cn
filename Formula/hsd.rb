require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://ghproxy.com/https://github.com/handshake-org/hsd/archive/v5.1.0.tar.gz"
  sha256 "26ea58625a2d2a650b5c5ab6298549d9322d94dbe77923891f587701989f6acb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "6e33b650cd716fa7c8f222a1647d80206cafe3b1a5737510e19d454db3b9f885"
    sha256                               arm64_monterey: "891e09d4fc846d9c28333bb7802adc3f58aeb97e1c43f8a7d531eb833189d62b"
    sha256                               arm64_big_sur:  "1a86e93df427d26c37970a7802e3485d20d7e89fc5a0e3621a6d6e3b07623bb9"
    sha256                               ventura:        "874d449265b346303794c5f2a3933ae695fe0fb7308d3d9c48ed022fde97c7e5"
    sha256                               monterey:       "f1a3506fe4aa86949cc468918117fb2de360495b7e2fc52bd55432bc2a26fe48"
    sha256                               big_sur:        "e05a3527a83d7c9a9b6d97eaec92e4a2817ebaec978b3c4d2cb765df9d6d295d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29fd069adcadcf9158a73c2245aee9f983dd690009778dfb395115e3b5694850"
  end

  depends_on "node"
  depends_on "unbound"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      const assert = require('assert');
      const hsd = require('#{libexec}/lib/node_modules/hsd');
      assert(hsd);

      const node = new hsd.FullNode({
        prefix: '#{testpath}/.hsd',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    EOS
    system Formula["node"].opt_bin/"node", testpath/"script.js"
    assert_predicate testpath/".hsd", :directory?
  end
end