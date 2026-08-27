class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.63.0.tgz"
  sha256 "301dfb07a8f295171ef065309ca5b481d06a2f6eb7da5500f6aca731fd446c04"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff5ad04b105cfc2f0989740c685129fb717b54f1dba116ff699f1c3491a10655"
    sha256 cellar: :any,                 arm64_sequoia: "ff5ad04b105cfc2f0989740c685129fb717b54f1dba116ff699f1c3491a10655"
    sha256 cellar: :any,                 arm64_sonoma:  "ff5ad04b105cfc2f0989740c685129fb717b54f1dba116ff699f1c3491a10655"
    sha256 cellar: :any,                 sonoma:        "9b8dd6cbb4cbf3ca8092976ead2b894029941431c072d2cf5cad00eb9690a2e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55b379b269442b5638fdee159f35b5bf0910f89b65d2831f2eff016173818afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9109c5ee3540ddc517557282e7fdf1f0bc73264a134b94e063bc1b52fb70ded"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
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