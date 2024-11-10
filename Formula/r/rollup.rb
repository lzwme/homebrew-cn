class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.25.0.tgz"
  sha256 "2e7f7f6bd027979c78afdbda9e3c0e21ea9245907ab22589dd864c8dfbace3a8"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e9744efc938ac8b96fe7e9b70c4fff01545ab15f4675a58723ab618574b832e"
    sha256 cellar: :any,                 arm64_sonoma:  "6e9744efc938ac8b96fe7e9b70c4fff01545ab15f4675a58723ab618574b832e"
    sha256 cellar: :any,                 arm64_ventura: "6e9744efc938ac8b96fe7e9b70c4fff01545ab15f4675a58723ab618574b832e"
    sha256 cellar: :any,                 sonoma:        "e30f7c28b34b567d450d4fca42e770e7a96e33872b4755dc17e051a124e31a59"
    sha256 cellar: :any,                 ventura:       "e30f7c28b34b567d450d4fca42e770e7a96e33872b4755dc17e051a124e31a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1c5173b368e0d0070e7674e829e907bf2128a9f5447979175c5f5b0d753311b"
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