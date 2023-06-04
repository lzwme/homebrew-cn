require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.6.3.tgz"
  sha256 "67eeb211b6d5d61b57d09df86a2e69a783e0eaf818607ce704276fc2ccd2de36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ea3c2b334b25756269fe5987a347e4f5c17fa915c3156cb2c2f82ab58cbaf2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ea3c2b334b25756269fe5987a347e4f5c17fa915c3156cb2c2f82ab58cbaf2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ea3c2b334b25756269fe5987a347e4f5c17fa915c3156cb2c2f82ab58cbaf2f"
    sha256 cellar: :any_skip_relocation, ventura:        "28f446bc0cdac1220a6c9a9148cad2ec170a358b34efda1cf3090d511a360d3d"
    sha256 cellar: :any_skip_relocation, monterey:       "28f446bc0cdac1220a6c9a9148cad2ec170a358b34efda1cf3090d511a360d3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "28f446bc0cdac1220a6c9a9148cad2ec170a358b34efda1cf3090d511a360d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ea3c2b334b25756269fe5987a347e4f5c17fa915c3156cb2c2f82ab58cbaf2f"
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