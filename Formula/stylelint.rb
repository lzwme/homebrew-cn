require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.6.1.tgz"
  sha256 "a6c1eec4ba3cf7b96ceb7f826e11ec7f61e2bec673477261eb0aa2f5b4448a9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c16d6c2ac90180e7afc16d0263821eb96832dc862a3e840f2b10d8c385779d95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c16d6c2ac90180e7afc16d0263821eb96832dc862a3e840f2b10d8c385779d95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c16d6c2ac90180e7afc16d0263821eb96832dc862a3e840f2b10d8c385779d95"
    sha256 cellar: :any_skip_relocation, ventura:        "2f8f3a8a408cb8893ade082c3fd332402f7a34c1846246adc7d1130fb96ff750"
    sha256 cellar: :any_skip_relocation, monterey:       "2f8f3a8a408cb8893ade082c3fd332402f7a34c1846246adc7d1130fb96ff750"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f8f3a8a408cb8893ade082c3fd332402f7a34c1846246adc7d1130fb96ff750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c16d6c2ac90180e7afc16d0263821eb96832dc862a3e840f2b10d8c385779d95"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end