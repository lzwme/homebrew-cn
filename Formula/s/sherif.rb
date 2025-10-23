class Sherif < Formula
  desc "Opinionated, zero-config linter for JavaScript monorepos"
  homepage "https://github.com/QuiiBz/sherif"
  url "https://registry.npmjs.org/sherif/-/sherif-1.7.0.tgz"
  sha256 "2ba365f0c39cbd5abcac61104c98dc224e8cf02fb7ae375119f16134b82ae2d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb04c325a0b0aa45a5e92beeffa29135c3f503dc7c7bce0303e8c66011ef4934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb04c325a0b0aa45a5e92beeffa29135c3f503dc7c7bce0303e8c66011ef4934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb04c325a0b0aa45a5e92beeffa29135c3f503dc7c7bce0303e8c66011ef4934"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ea0ca7c359cfc4c65fd56dcf1628b437ae95820b3fcf7c04f75ef78d331fe0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "610315f99ba555dab86f35d21e741d36e0c190df7e115be5aed99bd97b56ac56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f43aa0cff8d2361679abf900696cf4a029f59c585f4fbb820bf584392071881"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "private": true,
        "packageManager": "npm",
        "workspaces": [ "." ]
      }
    JSON
    (testpath/"test.js").write <<~JS
      console.log('Hello, world!');
    JS
    assert_match "No issues found", shell_output("#{bin}/sherif --no-install .")
  end
end