class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.34.2.tgz"
  sha256 "409c33c52e6fecd9f2f13d484d0355e7bc067b3f9e2b530016a6bb2f68118f3d"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "00a8b99e5fcf599bc88c5db0bafda4d45a8c53f42d3c97be543481ef733b8602"
    sha256 cellar: :any,                 arm64_sonoma:  "00a8b99e5fcf599bc88c5db0bafda4d45a8c53f42d3c97be543481ef733b8602"
    sha256 cellar: :any,                 arm64_ventura: "00a8b99e5fcf599bc88c5db0bafda4d45a8c53f42d3c97be543481ef733b8602"
    sha256 cellar: :any,                 sonoma:        "6894d74553b2423d7153db7e53be53703bd02410c8c1c4b69ca496d6ddcb61d2"
    sha256 cellar: :any,                 ventura:       "6894d74553b2423d7153db7e53be53703bd02410c8c1c4b69ca496d6ddcb61d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9467e94593992b6171a4f60ec9913bf6419523d3411b78c7162b2fcba9ebaa0c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test/main.js").write <<~JS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    JS

    (testpath/"test/foo.js").write <<~JS
      export default 'hello world!';
    JS

    expected = <<~JS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    JS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end