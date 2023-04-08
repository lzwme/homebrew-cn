require "language/node"

class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://ghproxy.com/https://github.com/joernio/astgen/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "2655420cbbd543d772244be87538dff9a2c8cfb691ac29b9cb2e81bbf5146a52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c542384f8bce37cd7fdeab810324ec05398510e1e8520fa26727651401604101"
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
    assert_match '"0":"Console"', (testpath/"out/main.js.typemap").read
  end
end