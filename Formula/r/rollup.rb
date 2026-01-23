class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.56.0.tgz"
  sha256 "9fd3342a7f96f6e02810617ad6409075578441be33794300545b4e4ef55a57e7"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "83c703a260b98cf0caa4fc810fff71e313c2ecd3ca6e9ab9d2511b654e8bf002"
    sha256 cellar: :any,                 arm64_sequoia: "0ef4c2359123552f7d43b20b9ab48bf73fa9362b50103b9e5626d91bb73b3cc2"
    sha256 cellar: :any,                 arm64_sonoma:  "0ef4c2359123552f7d43b20b9ab48bf73fa9362b50103b9e5626d91bb73b3cc2"
    sha256 cellar: :any,                 sonoma:        "8e20d59d17b608b20a5c20a0bbf84a729cebe1cd78f7c2a6e770134d6b9501b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfbfc7eed3e0f26eede406e1c06a617483ebeb1ba0a35099e8c9d67b1615dbc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69560823fa63d7140d716169100174db8ca81919efd9cbbfc2c12019150ca16f"
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