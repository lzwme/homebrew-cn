class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.22.4.tgz"
  sha256 "57583167ce834856f9f1bb1b886bbf09859f8da3df9cafc13047c750ca033a1b"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb5092cc9261ca510e366cadaf12184a9a55f817e4c3528e71a8c1e876f0881f"
    sha256 cellar: :any,                 arm64_sonoma:  "cb5092cc9261ca510e366cadaf12184a9a55f817e4c3528e71a8c1e876f0881f"
    sha256 cellar: :any,                 arm64_ventura: "cb5092cc9261ca510e366cadaf12184a9a55f817e4c3528e71a8c1e876f0881f"
    sha256 cellar: :any,                 sonoma:        "a4eff8bfb9b92d6172f7400dc840bc1455de8e26b1cb1bd14bd28b97857cf72c"
    sha256 cellar: :any,                 ventura:       "a4eff8bfb9b92d6172f7400dc840bc1455de8e26b1cb1bd14bd28b97857cf72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c9042f8a23084f63aeb3998f7741c0d73013cce9039e3800663e10ebaba4d9"
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