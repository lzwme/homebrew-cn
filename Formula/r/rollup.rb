class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.19.2.tgz"
  sha256 "352fcb85b3d0d5e5715ca9800ccba12448528d95a2ff278485f23f5ba9b44449"
  license all_of: ["ISC", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ee374cbe8476fced83dd74237d8ddd0330827a1924d8651c370e137a04915e2a"
    sha256 cellar: :any,                 arm64_ventura:  "ee374cbe8476fced83dd74237d8ddd0330827a1924d8651c370e137a04915e2a"
    sha256 cellar: :any,                 arm64_monterey: "ee374cbe8476fced83dd74237d8ddd0330827a1924d8651c370e137a04915e2a"
    sha256 cellar: :any,                 sonoma:         "84df2e8ad46d055558e0bbee78e210feccaacc2b50dd05041789d68dd32e57e3"
    sha256 cellar: :any,                 ventura:        "84df2e8ad46d055558e0bbee78e210feccaacc2b50dd05041789d68dd32e57e3"
    sha256 cellar: :any,                 monterey:       "84df2e8ad46d055558e0bbee78e210feccaacc2b50dd05041789d68dd32e57e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a95e0e64ee2bab85973358526bf67b37235ccd87fbb89ee4c776623117020b9"
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