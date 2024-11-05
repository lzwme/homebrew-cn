class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.24.4.tgz"
  sha256 "770449e5bf30660dcfe72a35e12b28699795952b1eea3885f824b64b78ed1503"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "265ec5eee5dd8459a0848aea6d849c5b245de432b91beeea6cc687ee56b2eaad"
    sha256 cellar: :any,                 arm64_sonoma:  "265ec5eee5dd8459a0848aea6d849c5b245de432b91beeea6cc687ee56b2eaad"
    sha256 cellar: :any,                 arm64_ventura: "265ec5eee5dd8459a0848aea6d849c5b245de432b91beeea6cc687ee56b2eaad"
    sha256 cellar: :any,                 sonoma:        "b47f890be1c047a6a238656336f28765249340c34be188226f142288da276eac"
    sha256 cellar: :any,                 ventura:       "b47f890be1c047a6a238656336f28765249340c34be188226f142288da276eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4c0893d7408a4703ca814dda8b48e0f9c8c513aba501a34c8704977c935ba1"
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