class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.62.4.tgz"
  sha256 "cbfbee7b3e5a130bb288b3c723a85df4d4df6ed8fe194ffe52c4a89575e74615"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1877cf3824fe16b60b0fd5a8811ccdea60ed3f743e17c8e46092d7992a63625a"
    sha256 cellar: :any,                 arm64_sequoia: "1877cf3824fe16b60b0fd5a8811ccdea60ed3f743e17c8e46092d7992a63625a"
    sha256 cellar: :any,                 arm64_sonoma:  "1877cf3824fe16b60b0fd5a8811ccdea60ed3f743e17c8e46092d7992a63625a"
    sha256 cellar: :any,                 sonoma:        "b1d4f0a325e6a02268c449f752923047e66a79965cb673ae0f448ecd0e500d5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20b516631dc78c690c4fc035529349d5501e017c6eb989f1f4ce30fb26be2fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4457a5c2b354f33c54d0cc3f10bc5d44a039fe242eafd5604b886ab26b74f5aa"
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