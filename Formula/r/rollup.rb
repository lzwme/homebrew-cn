class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.46.4.tgz"
  sha256 "dfeaa5b66a281179ccc83545dcb8aa0ee156fe2d50249946cc188a134b684d53"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8189f8f5b4a475f41233124dbadc8701307ed5485527d5cff74ea05448903503"
    sha256 cellar: :any,                 arm64_sonoma:  "8189f8f5b4a475f41233124dbadc8701307ed5485527d5cff74ea05448903503"
    sha256 cellar: :any,                 arm64_ventura: "8189f8f5b4a475f41233124dbadc8701307ed5485527d5cff74ea05448903503"
    sha256 cellar: :any,                 sonoma:        "27432d95fd6060045eac02f7c43ffec7ea2bbf27ad35ea78750f30e245e6c67c"
    sha256 cellar: :any,                 ventura:       "27432d95fd6060045eac02f7c43ffec7ea2bbf27ad35ea78750f30e245e6c67c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15fa7823ccaebb5c6f05d6a259aa80da2454d09bcdeb828fc2e31707004cf702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72360daa327b84a3c17968418b4155f024403968a788789dec8ebdbab19ecf98"
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