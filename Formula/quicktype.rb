require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.36.tgz"
  sha256 "d29bbfebc0b83fbf07fca4263bc0878cbec162647e3346d0ca31b7345fac0cfb"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c16b363e681b7c66f5238be0b3e21f5ad74db19d0aa8403884908e6a1efc319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c16b363e681b7c66f5238be0b3e21f5ad74db19d0aa8403884908e6a1efc319"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c16b363e681b7c66f5238be0b3e21f5ad74db19d0aa8403884908e6a1efc319"
    sha256 cellar: :any_skip_relocation, ventura:        "0c6b9e0da60f36249b5be5b0d99006e8c461c6b3be607129a1cdcf61b8b13f57"
    sha256 cellar: :any_skip_relocation, monterey:       "0c6b9e0da60f36249b5be5b0d99006e8c461c6b3be607129a1cdcf61b8b13f57"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c6b9e0da60f36249b5be5b0d99006e8c461c6b3be607129a1cdcf61b8b13f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c16b363e681b7c66f5238be0b3e21f5ad74db19d0aa8403884908e6a1efc319"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end