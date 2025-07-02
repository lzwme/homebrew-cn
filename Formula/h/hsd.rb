class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https:handshake.org"
  url "https:github.comhandshake-orghsdarchiverefstagsv8.0.0.tar.gz"
  sha256 "1de0ebbbac6ca35d62353227176c7377203a82efbc27fdf08ad23dedb481ee28"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "f49020038dd503ff20678bd72730f297a62d652171f0f6e92c4905308fa825a1"
    sha256                               arm64_sonoma:  "bafc25d3b6c841544f70926bdb877bd5c1b802066ead9b0cb1c5651c5d38b057"
    sha256                               arm64_ventura: "1950c44d5aefc46de62db6c7382849bd886d6f4551f811bd43f88342cb9820b0"
    sha256                               sonoma:        "eec81a814a324c3e71c090f55c09700d523300d48c11ebc224546f56ae507041"
    sha256                               ventura:       "2a474e169e574e73679e2f59c40a065f633efa631fd54ef519ba1e2184393c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b04ee8d7c2ee6af1ad78bcaf01aedc56612e7222d9ac1a383f5eb66f1e548103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdb19ae0e6840855a4d49bdfd7113e0d5bf4e72abcec970a23dda6cbccc5789f"
  end

  depends_on "node"
  depends_on "unbound"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec"bin*"]
  end

  test do
    (testpath"script.js").write <<~JS
      const assert = require('assert');
      const hsd = require('#{libexec}libnode_moduleshsd');
      assert(hsd);

      const node = new hsd.FullNode({
        prefix: '#{testpath}.hsd',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    JS
    system Formula["node"].opt_bin"node", testpath"script.js"
    assert_predicate testpath".hsd", :directory?
  end
end