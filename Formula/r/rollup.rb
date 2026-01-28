class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.57.0.tgz"
  sha256 "4628574eca477a4dbee0f28b3138024086f70157115bbc0900fab30a49244361"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cc7b43eae681b910393d2c810f272a0beee7127d129a89dc841dbe7e699c664"
    sha256 cellar: :any,                 arm64_sequoia: "0ce0e5118a7853fa1f8adb1977f2a217931723c8e64f13ddb11e51edd7554215"
    sha256 cellar: :any,                 arm64_sonoma:  "0ce0e5118a7853fa1f8adb1977f2a217931723c8e64f13ddb11e51edd7554215"
    sha256 cellar: :any,                 sonoma:        "bba19559df2408d71075d98bfe494e1a2d5c2db441cc2af1a07af0b8f2db539f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00d971e7b467cf9003696a3c039468ce2c4dc9493aef1575a597d37e5783646a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ac1897b4e81e47541648e798e1f83cf3a774b03d739b63c5ee180675c13f5c"
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