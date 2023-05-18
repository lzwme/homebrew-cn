require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.6.2.tgz"
  sha256 "abd0004561463abfbbedf27e61d26cf890880cf1baf0f9a1df0ff1bb60509c8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c3e08f687b46d346222ce237296e42eeda3385400b2d52fbe8b9f2f3383ab2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c3e08f687b46d346222ce237296e42eeda3385400b2d52fbe8b9f2f3383ab2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c3e08f687b46d346222ce237296e42eeda3385400b2d52fbe8b9f2f3383ab2e"
    sha256 cellar: :any_skip_relocation, ventura:        "acae9278b35d7ac7b44b3fd3d645b2c657a9ea18c9b5233c0978ceabd7de4e56"
    sha256 cellar: :any_skip_relocation, monterey:       "acae9278b35d7ac7b44b3fd3d645b2c657a9ea18c9b5233c0978ceabd7de4e56"
    sha256 cellar: :any_skip_relocation, big_sur:        "acae9278b35d7ac7b44b3fd3d645b2c657a9ea18c9b5233c0978ceabd7de4e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3e08f687b46d346222ce237296e42eeda3385400b2d52fbe8b9f2f3383ab2e"
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