class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.44.0.tgz"
  sha256 "80bc159c0cd9dc82436b89ab7501bccf947d0ba048677933fa020b7f7a0b5aa1"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1c30aedada0555cb71b70249aa41497139c1d63e6d32c522283299586667855"
    sha256 cellar: :any,                 arm64_sonoma:  "e1c30aedada0555cb71b70249aa41497139c1d63e6d32c522283299586667855"
    sha256 cellar: :any,                 arm64_ventura: "e1c30aedada0555cb71b70249aa41497139c1d63e6d32c522283299586667855"
    sha256 cellar: :any,                 sonoma:        "6c7b0934ac423ec6d674eeddd73ed845ec44874076e95e6b92d06cdfa3607e4f"
    sha256 cellar: :any,                 ventura:       "6c7b0934ac423ec6d674eeddd73ed845ec44874076e95e6b92d06cdfa3607e4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c41433fb8f59283a526361b8403b8d027305bb0c2580b6760bdccd366ec6632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5dfa8d6892109f32c250e8d4ab0412d1b099784c0810518c17ed97d312dbe9d"
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