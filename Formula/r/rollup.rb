class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.22.2.tgz"
  sha256 "d7ad643d115b704a0ac69c69dd281b56c458c5abcbba4043e658bd7faa3292c1"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "984b34ca0c991ac77692ad89b249d0f0823472306eb91f7b452f006e89b0d105"
    sha256 cellar: :any,                 arm64_sonoma:  "984b34ca0c991ac77692ad89b249d0f0823472306eb91f7b452f006e89b0d105"
    sha256 cellar: :any,                 arm64_ventura: "984b34ca0c991ac77692ad89b249d0f0823472306eb91f7b452f006e89b0d105"
    sha256 cellar: :any,                 sonoma:        "5b9dfe91bc990d356b91841beede43e61c92c5b4ea4026624907e71344e0c285"
    sha256 cellar: :any,                 ventura:       "5b9dfe91bc990d356b91841beede43e61c92c5b4ea4026624907e71344e0c285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "094573770344b5a9548cc6b1e69ddc40a7e1297dceb7109dee828d86606df3a2"
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