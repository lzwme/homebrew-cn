class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.30.0.tgz"
  sha256 "b32eba18ff8c933580b53a94cffe007c2353acfe5c667e13926f44cbc7842066"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19e2da70c5c375de17193bf81348271fbe00c93b835e950b6014a582e6b5f51c"
    sha256 cellar: :any,                 arm64_sequoia: "1bd097c1adc1bea2f250bc3925c9268178d8bad603a573dd6b28455b3592b081"
    sha256 cellar: :any,                 arm64_sonoma:  "1bd097c1adc1bea2f250bc3925c9268178d8bad603a573dd6b28455b3592b081"
    sha256 cellar: :any,                 sonoma:        "de9978bd452558c7d55a87069216fe87c3672fc02d003cc11b951664ca5062cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad128ee25e7f4df20877f39b7e6d3c3363aa01e37ec9303c809665d04619bac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f0e37214a713e9c79c172b4d791c45606379cddf6ccb2a30c2908033cbcfeba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end