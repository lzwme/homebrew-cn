class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https:handshake.org"
  url "https:github.comhandshake-orghsdarchiverefstagsv7.0.0.tar.gz"
  sha256 "1575078ebda85396fcaa32238580ae4295ea2f3903bac1ffd97ef7dc77ea363c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "8a888c6370e29963fde04a7fb6eccd2776b406ba80fa508a3aa84313b1f61769"
    sha256                               arm64_sonoma:  "bc44f24c70c3a7e61073d2b9f18f69b7b667554c5b98fb15ec47c7cf07c5759e"
    sha256                               arm64_ventura: "abdca27a97cd18ecd3969c05a364636effd180db97c2aa5cbef665905f2f15d4"
    sha256                               sonoma:        "f741897e398391aab16f5bd42ee1c8f252f8c11f1c7967767c6c55070ab4b368"
    sha256                               ventura:       "b000053a108c7251724adeffb14fa45afd9da36b66bd4dba2c26e69f02962aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "567a06032591728df4091b459d34c8655789730ba0bc385ff9de987893d14507"
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