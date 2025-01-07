class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.30.0.tgz"
  sha256 "5e0efd7ca3582abac344f8405cbcdef0d1fcdd0e96c87421fca241464326c672"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b7195daf63886adee204f3871713724f27a838eb8ef98efff88a815ff38b4d14"
    sha256 cellar: :any,                 arm64_sonoma:  "b7195daf63886adee204f3871713724f27a838eb8ef98efff88a815ff38b4d14"
    sha256 cellar: :any,                 arm64_ventura: "b7195daf63886adee204f3871713724f27a838eb8ef98efff88a815ff38b4d14"
    sha256 cellar: :any,                 sonoma:        "e98a2012b2b3e8d98ba549e9054128b8d1e2ec05bd432a234a7477bef79bf9c3"
    sha256 cellar: :any,                 ventura:       "e98a2012b2b3e8d98ba549e9054128b8d1e2ec05bd432a234a7477bef79bf9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eadd9ee0a3781fab8c0bc303481d6aba8760f93eeae34a1880e08bc37790183"
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