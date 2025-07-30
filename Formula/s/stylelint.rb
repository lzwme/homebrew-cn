class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.23.0.tgz"
  sha256 "316d6fc0af7960ce48c4993614611b69d44cbc4ee66ea173721029d493ff5443"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e05b9a4aba5095d6202c6558bfe08928edf3a3d4b0f23109366b959fec7021e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e05b9a4aba5095d6202c6558bfe08928edf3a3d4b0f23109366b959fec7021e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e05b9a4aba5095d6202c6558bfe08928edf3a3d4b0f23109366b959fec7021e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "69b7f607b92997056f82e561e91f1b19d39d980668f6c247d4e5add5ba5f8190"
    sha256 cellar: :any_skip_relocation, ventura:       "69b7f607b92997056f82e561e91f1b19d39d980668f6c247d4e5add5ba5f8190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e05b9a4aba5095d6202c6558bfe08928edf3a3d4b0f23109366b959fec7021e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e05b9a4aba5095d6202c6558bfe08928edf3a3d4b0f23109366b959fec7021e9"
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