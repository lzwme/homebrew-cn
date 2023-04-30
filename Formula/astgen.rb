require "language/node"

class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://ghproxy.com/https://github.com/joernio/astgen/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "e8bb0ced3dc1fc3f7790780d03bce238eac9b3ac63d3c84dfa6afe66523309a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d9712a0f9815b8b158519851b8f4147026b0167fb6ce9d0a22b59e6c2eb16379"
  end

  depends_on "node"

  def install
    # Disable custom postinstall script
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--ignore-scripts"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"main.js").write <<~EOS
      console.log("Hello, world!");
    EOS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match '"fullName": "main.js"', (testpath/"out/main.js.json").read
    assert_match '"0": "Console"', (testpath/"out/main.js.typemap").read
  end
end