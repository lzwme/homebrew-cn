class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.16.0.tgz"
  sha256 "7e69fc0625ff48b24390c25e5a02e7a1c59c0cb1d9763a960dd05ac9cfdda68e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40ef4b12d31ab87e650aabb84e3f88dc7785a4c14e2d396ebf502844943243fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40ef4b12d31ab87e650aabb84e3f88dc7785a4c14e2d396ebf502844943243fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40ef4b12d31ab87e650aabb84e3f88dc7785a4c14e2d396ebf502844943243fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "39db02235a5c613441e0ab988da3932b67279daf4f27961e27d2756b893a98f0"
    sha256 cellar: :any_skip_relocation, ventura:       "39db02235a5c613441e0ab988da3932b67279daf4f27961e27d2756b893a98f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f4c90ff5155d542980ebdd5716fba32a3f5817e5b900b4372fd01a92336085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40ef4b12d31ab87e650aabb84e3f88dc7785a4c14e2d396ebf502844943243fd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~JSON
      {
        "rules": {
          "block-no-empty": true
        }
      }
    JSON

    (testpath/"test.css").write <<~CSS
      a {
      }
    CSS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end