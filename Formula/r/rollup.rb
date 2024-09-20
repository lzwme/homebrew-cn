class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.22.0.tgz"
  sha256 "ba027cf1e744cb0468e8ddbd314bbe74fc2256de217cbfefc3b843cf3a004258"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "255145647535cf52cb84343be5c26ae2eafc360a4631976de191b661b4dbb9d7"
    sha256 cellar: :any,                 arm64_sonoma:  "255145647535cf52cb84343be5c26ae2eafc360a4631976de191b661b4dbb9d7"
    sha256 cellar: :any,                 arm64_ventura: "255145647535cf52cb84343be5c26ae2eafc360a4631976de191b661b4dbb9d7"
    sha256 cellar: :any,                 sonoma:        "649197f1e0b12d23443223963aba6a112234dfc8465e6cb087203b7e5079eedd"
    sha256 cellar: :any,                 ventura:       "649197f1e0b12d23443223963aba6a112234dfc8465e6cb087203b7e5079eedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a9578ca2450b32556d162441f3167c42ce3b049e896914e937aa36176d451b9"
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