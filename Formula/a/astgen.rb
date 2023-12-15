require "language/node"

class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://ghproxy.com/https://github.com/joernio/astgen/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "ad5ea372399557431889fd2d0399542d33ed9a789a64d45180c8925cc76ef7cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d663dbadfd9d5e3e2e0ecb0da5c402d6e691960b1f7f3a7af0a2a42b01439b5"
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