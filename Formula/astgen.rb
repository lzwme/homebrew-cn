require "language/node"

class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://ghproxy.com/https://github.com/joernio/astgen/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "414afa102fb62ef8d4b2085e53e3b466c1e330188c392fbd616fba900b3548ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "745ca1dfe7840ace17f24165c652376b9097428c4e6f9c3a535c4eb195478da4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "745ca1dfe7840ace17f24165c652376b9097428c4e6f9c3a535c4eb195478da4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "745ca1dfe7840ace17f24165c652376b9097428c4e6f9c3a535c4eb195478da4"
    sha256 cellar: :any_skip_relocation, ventura:        "745ca1dfe7840ace17f24165c652376b9097428c4e6f9c3a535c4eb195478da4"
    sha256 cellar: :any_skip_relocation, monterey:       "745ca1dfe7840ace17f24165c652376b9097428c4e6f9c3a535c4eb195478da4"
    sha256 cellar: :any_skip_relocation, big_sur:        "745ca1dfe7840ace17f24165c652376b9097428c4e6f9c3a535c4eb195478da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd60603fc6d722fe83e7e6658d8bdbc1902fd286df5b136ce3278607995c76c5"
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