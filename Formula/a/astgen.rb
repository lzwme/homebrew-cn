require "language/node"

class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://ghproxy.com/https://github.com/joernio/astgen/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "aaec054bb66b0c38699c1601c68b331fa09d1c34619a0a1d0a3b5ca4ba8dba3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "17e90e5aa92df21c0dd11e8138b86571686459eac7d056b6458c381593df5fe4"
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