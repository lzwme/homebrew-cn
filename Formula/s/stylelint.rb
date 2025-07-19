class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.22.0.tgz"
  sha256 "ae600b4be4a67d18c039469bbd36dc280a93ad064394c0bac1c6a2b7f6f34f2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55e0106d5808c7d9d22649c95a38a176629d3c20941488f29efc487dd7755fc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55e0106d5808c7d9d22649c95a38a176629d3c20941488f29efc487dd7755fc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55e0106d5808c7d9d22649c95a38a176629d3c20941488f29efc487dd7755fc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "17f5e8a9571e881ea1bd1f27426a6d58e3d80c51cb08d28612b8a499e7c35cb6"
    sha256 cellar: :any_skip_relocation, ventura:       "17f5e8a9571e881ea1bd1f27426a6d58e3d80c51cb08d28612b8a499e7c35cb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55e0106d5808c7d9d22649c95a38a176629d3c20941488f29efc487dd7755fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55e0106d5808c7d9d22649c95a38a176629d3c20941488f29efc487dd7755fc9"
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