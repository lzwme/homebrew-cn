require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.0.0.tgz"
  sha256 "8ffa84b6a7498e4eec42c3ca6667ce17ed168e294d33128a2e1043a004734b5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5c94ca9b922de76428493af3f9d6ea965313bb9cb3c3e1c5180bf8bdc95e143"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5c94ca9b922de76428493af3f9d6ea965313bb9cb3c3e1c5180bf8bdc95e143"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5c94ca9b922de76428493af3f9d6ea965313bb9cb3c3e1c5180bf8bdc95e143"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1f6f2914fe404eeafb691baeb472da66ca445749ce3b2e18809826abd5e1701"
    sha256 cellar: :any_skip_relocation, ventura:        "d1f6f2914fe404eeafb691baeb472da66ca445749ce3b2e18809826abd5e1701"
    sha256 cellar: :any_skip_relocation, monterey:       "d1f6f2914fe404eeafb691baeb472da66ca445749ce3b2e18809826abd5e1701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5c94ca9b922de76428493af3f9d6ea965313bb9cb3c3e1c5180bf8bdc95e143"
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