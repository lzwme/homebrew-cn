require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.27.0.tgz"
  sha256 "5405a76529add39d856a508a1d8d6e74741149cf2624b68fe9e40105031f2dd0"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abdbfdfb87f320c406edc7989981fc6194e3e2dff78bb2eb0ee776f007e6fdf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abdbfdfb87f320c406edc7989981fc6194e3e2dff78bb2eb0ee776f007e6fdf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abdbfdfb87f320c406edc7989981fc6194e3e2dff78bb2eb0ee776f007e6fdf2"
    sha256 cellar: :any_skip_relocation, ventura:        "70c7386c9ccf6e5fd39a3f83e6149a8da6ffc3c4c0e7daf8e941c49cde114a55"
    sha256 cellar: :any_skip_relocation, monterey:       "70c7386c9ccf6e5fd39a3f83e6149a8da6ffc3c4c0e7daf8e941c49cde114a55"
    sha256 cellar: :any_skip_relocation, big_sur:        "70c7386c9ccf6e5fd39a3f83e6149a8da6ffc3c4c0e7daf8e941c49cde114a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8864bb3bfbea57c4d0ed940349e91de798dd20d2a6fbb33fd28b499e8010bb2"
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