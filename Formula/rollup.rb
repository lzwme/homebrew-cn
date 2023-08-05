require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.27.2.tgz"
  sha256 "24d857be298c4c8ad235e8c67d84bc2425b90c212c4c40b60265b9a28c77f181"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "684fe29cead6acc42f7e5a61c5274bcdace0b75d23795ffa5e19be19a12f6926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "684fe29cead6acc42f7e5a61c5274bcdace0b75d23795ffa5e19be19a12f6926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "684fe29cead6acc42f7e5a61c5274bcdace0b75d23795ffa5e19be19a12f6926"
    sha256 cellar: :any_skip_relocation, ventura:        "e01d3f7991817147b049a821ae2186adc614778feaf312a28dae571cb3d44fa6"
    sha256 cellar: :any_skip_relocation, monterey:       "e01d3f7991817147b049a821ae2186adc614778feaf312a28dae571cb3d44fa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e01d3f7991817147b049a821ae2186adc614778feaf312a28dae571cb3d44fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "019e4e522d80fc56040d48a631f9145d1610c5bd066c89d96bfc99711d5fed16"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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