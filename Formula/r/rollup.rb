class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.21.1.tgz"
  sha256 "52316500e69fdfbe1c96b30853fc9ff79c5f3dd079850e259b2e9562fd21e351"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2870486e21415733a998a862cb6cfcc48c3f25f20b930cdb83f21914d45dab34"
    sha256 cellar: :any,                 arm64_ventura:  "2870486e21415733a998a862cb6cfcc48c3f25f20b930cdb83f21914d45dab34"
    sha256 cellar: :any,                 arm64_monterey: "2870486e21415733a998a862cb6cfcc48c3f25f20b930cdb83f21914d45dab34"
    sha256 cellar: :any,                 sonoma:         "3332f69fe9fe5cfdcc4a37dad5f13eb5d90d837a664fb9517601beb643cf01d6"
    sha256 cellar: :any,                 ventura:        "3332f69fe9fe5cfdcc4a37dad5f13eb5d90d837a664fb9517601beb643cf01d6"
    sha256 cellar: :any,                 monterey:       "3332f69fe9fe5cfdcc4a37dad5f13eb5d90d837a664fb9517601beb643cf01d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bad06b570a68441589e18b8d3940e52dbd79ea3ee76416de21bda189dbd32fcb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end