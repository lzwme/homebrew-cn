class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.62.3.tgz"
  sha256 "58066473f62eb226ec8d07f937c3a7700288967021c28b36ac506c0c25877107"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "012fb58e152a55a06f8f4e5057e68be90dbe9a9937992a7a8dce072003d3e9d6"
    sha256 cellar: :any,                 arm64_sequoia: "012fb58e152a55a06f8f4e5057e68be90dbe9a9937992a7a8dce072003d3e9d6"
    sha256 cellar: :any,                 arm64_sonoma:  "012fb58e152a55a06f8f4e5057e68be90dbe9a9937992a7a8dce072003d3e9d6"
    sha256 cellar: :any,                 sonoma:        "fa61106fd43613d3c453b9ee1e3b79c539cae9c7b5f8b644aa3476b0f238ab6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "928f673a595df34afda7fbdd2581358d7c0736c9378d740fd4add26deb08888f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dc770abfd85a8368b432568f59a28cd8dd86dda9be0f838b1827708533a0d1a"
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