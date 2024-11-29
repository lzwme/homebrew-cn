class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.11.0.tgz"
  sha256 "efda48a20c03da3469655098d6c0e86275129be5ab4034ccb0bfb282f61adb4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b390a12fa632f42100363542fb1621eeb6b0264e7094d136b103dd554f6bed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75b390a12fa632f42100363542fb1621eeb6b0264e7094d136b103dd554f6bed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75b390a12fa632f42100363542fb1621eeb6b0264e7094d136b103dd554f6bed"
    sha256 cellar: :any_skip_relocation, sonoma:        "40e082be713e4ee14c7518197661e9254b8f068cbd31628149879d8b5da67215"
    sha256 cellar: :any_skip_relocation, ventura:       "40e082be713e4ee14c7518197661e9254b8f068cbd31628149879d8b5da67215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b390a12fa632f42100363542fb1621eeb6b0264e7094d136b103dd554f6bed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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