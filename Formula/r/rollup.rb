require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.6.0.tgz"
  sha256 "2a1532944ff4ff8cddc3f664d0b7f6485072aec0318f6d1d731b6973b7962a21"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "686e91afe5ff7f7ea07252b504d7db666050f6c8ce9d24f953ba95ee645a15aa"
    sha256 cellar: :any,                 arm64_ventura:  "686e91afe5ff7f7ea07252b504d7db666050f6c8ce9d24f953ba95ee645a15aa"
    sha256 cellar: :any,                 arm64_monterey: "686e91afe5ff7f7ea07252b504d7db666050f6c8ce9d24f953ba95ee645a15aa"
    sha256 cellar: :any,                 sonoma:         "41411b0f883f193702b2102607db66c0295e6632efeb08a2a9f7059dbf8b210e"
    sha256 cellar: :any,                 ventura:        "41411b0f883f193702b2102607db66c0295e6632efeb08a2a9f7059dbf8b210e"
    sha256 cellar: :any,                 monterey:       "41411b0f883f193702b2102607db66c0295e6632efeb08a2a9f7059dbf8b210e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d9bbd3a4a599db2eeadd1def226b810b87581045dc949b09943474f6a23369d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

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