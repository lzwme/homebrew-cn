class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.39.0.tgz"
  sha256 "ebba578bbf83e32c1236ba8dc8829683284606b2dbfb29b99cecdf2ee78b693c"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ee33acbe4902c68dc1593b3e04107f626391685991451a3dedd85d701c52c49c"
    sha256 cellar: :any,                 arm64_sonoma:  "ee33acbe4902c68dc1593b3e04107f626391685991451a3dedd85d701c52c49c"
    sha256 cellar: :any,                 arm64_ventura: "ee33acbe4902c68dc1593b3e04107f626391685991451a3dedd85d701c52c49c"
    sha256 cellar: :any,                 sonoma:        "a4a4cac3bb1509ddc2672b3149b3c1acd6b4136246edf940b417a992d4f26511"
    sha256 cellar: :any,                 ventura:       "a4a4cac3bb1509ddc2672b3149b3c1acd6b4136246edf940b417a992d4f26511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1594b24e82dc2315a3ebe14ccf17621a7364d329fd574f59ea03782003add03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49afce65788827789c09e3248db72f0c8c51e612071d2fdc489d379f9a99b319"
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