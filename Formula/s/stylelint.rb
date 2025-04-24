class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.19.0.tgz"
  sha256 "6e78dae55aa0656f4757a25eb81104b73df27f738b0c14b9c7c6e48c99cb3d58"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f398d1bbfe13b1b87186987c860f51d45c63baa621164c6b677536a50c0af8b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f398d1bbfe13b1b87186987c860f51d45c63baa621164c6b677536a50c0af8b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f398d1bbfe13b1b87186987c860f51d45c63baa621164c6b677536a50c0af8b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c31da130e0c9e1a121297f92a3398b6139659686ede4488da97db79c07244ece"
    sha256 cellar: :any_skip_relocation, ventura:       "c31da130e0c9e1a121297f92a3398b6139659686ede4488da97db79c07244ece"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f398d1bbfe13b1b87186987c860f51d45c63baa621164c6b677536a50c0af8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f398d1bbfe13b1b87186987c860f51d45c63baa621164c6b677536a50c0af8b8"
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