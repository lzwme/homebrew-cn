require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.7.0.tgz"
  sha256 "9a2305f0edc46b6d512fa13b9b8e153bec6313315fded646f97c3b3638292405"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "230776a467dfd0bd5edfa5ff6ed4a92ed02761d9e3f2aa74a2167d8b1a919ccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "230776a467dfd0bd5edfa5ff6ed4a92ed02761d9e3f2aa74a2167d8b1a919ccb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "230776a467dfd0bd5edfa5ff6ed4a92ed02761d9e3f2aa74a2167d8b1a919ccb"
    sha256 cellar: :any_skip_relocation, sonoma:         "33e2c60f36e298102fc677c2c4ccffb5e44af14efcb93d31df3057b4476586d0"
    sha256 cellar: :any_skip_relocation, ventura:        "33e2c60f36e298102fc677c2c4ccffb5e44af14efcb93d31df3057b4476586d0"
    sha256 cellar: :any_skip_relocation, monterey:       "33e2c60f36e298102fc677c2c4ccffb5e44af14efcb93d31df3057b4476586d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fc0f0bd691e13e5410483117d7442eefad612f75842103772e154f49642dbb9"
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