class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.44.2.tgz"
  sha256 "76636de21af949a0b598ea75bf9078ccc19553c6f607d9c7a3db61d7af5dbda4"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "307180027aaeaa9b875da5a67e6a2e3f5f2780c4504e97cfd3237f15722caed0"
    sha256 cellar: :any,                 arm64_sonoma:  "307180027aaeaa9b875da5a67e6a2e3f5f2780c4504e97cfd3237f15722caed0"
    sha256 cellar: :any,                 arm64_ventura: "307180027aaeaa9b875da5a67e6a2e3f5f2780c4504e97cfd3237f15722caed0"
    sha256 cellar: :any,                 sonoma:        "2d1606d9d32302ceafbe1964a27c3ee570bd8ff71e786dadb5cb22990e83351f"
    sha256 cellar: :any,                 ventura:       "2d1606d9d32302ceafbe1964a27c3ee570bd8ff71e786dadb5cb22990e83351f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a735dc15bf90e99eff86323b91e94a18c853f06e2b8d34ae5e50e96161a297d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "843e0a5a794794d718e58b459ff7ff888c20052f3919ef1d3d315d3ea00904c7"
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