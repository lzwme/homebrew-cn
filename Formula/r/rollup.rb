class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.55.2.tgz"
  sha256 "f950368efef191e0d0b2b52c9dd644158433f245cf4a5923a15aa5e12cd65c15"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "616519b127816d647ca6d4215e02712ca813604865cdf8b4d3c83ed7f55cb9db"
    sha256 cellar: :any,                 arm64_sequoia: "236b9ffff27e1a23ab6ef05f2626f7551a5651722e4c53cbf47a777e7a703327"
    sha256 cellar: :any,                 arm64_sonoma:  "236b9ffff27e1a23ab6ef05f2626f7551a5651722e4c53cbf47a777e7a703327"
    sha256 cellar: :any,                 sonoma:        "726694a465515081b0115d479f73b7e5b9acc3fa9574a0aa138be45b8fe4144e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce31db10075cf544006e014ae469a84b3a09dd24b309cfcd677f370572f3353c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31b54fc3eed2b5af4fe7d94d53a1658bbb114b1e111f9e7d0aab6a80bb2d7222"
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