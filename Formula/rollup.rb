require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.21.1.tgz"
  sha256 "35f43f428e8004de59dc64aa47a0843527f285b09dcc841039e74c0d7f6895a8"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab3f30f9c3cdf01f9bf8664da6b5ae8dc5db9874d0077eae10439d521770db2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab3f30f9c3cdf01f9bf8664da6b5ae8dc5db9874d0077eae10439d521770db2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab3f30f9c3cdf01f9bf8664da6b5ae8dc5db9874d0077eae10439d521770db2c"
    sha256 cellar: :any_skip_relocation, ventura:        "2e4e4e3296ba1e713fb60c916e20db738cfa9fa1b3b696865dc4eaac660b7d4b"
    sha256 cellar: :any_skip_relocation, monterey:       "2e4e4e3296ba1e713fb60c916e20db738cfa9fa1b3b696865dc4eaac660b7d4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e4e4e3296ba1e713fb60c916e20db738cfa9fa1b3b696865dc4eaac660b7d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "628b9737ab035b40d7a59e1b3ee68f5c2086e0f180aa0c29ca68da730b994f0f"
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