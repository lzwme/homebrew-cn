require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.77.tgz"
  sha256 "bb1a0a4dcdb6797f9723b0121ac17f52b65c57443ace2d92df6081ac7d90fed4"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cd21f286f0f16b27fdcffdbff81f91643ed1fa4123ab4e182491f1101297cb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cd21f286f0f16b27fdcffdbff81f91643ed1fa4123ab4e182491f1101297cb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cd21f286f0f16b27fdcffdbff81f91643ed1fa4123ab4e182491f1101297cb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5eb7f7b360ed6a0a89a76eab11ffb965c670b86e71c9b22cbfd90a9f0a21f4d5"
    sha256 cellar: :any_skip_relocation, ventura:        "5eb7f7b360ed6a0a89a76eab11ffb965c670b86e71c9b22cbfd90a9f0a21f4d5"
    sha256 cellar: :any_skip_relocation, monterey:       "5eb7f7b360ed6a0a89a76eab11ffb965c670b86e71c9b22cbfd90a9f0a21f4d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd21f286f0f16b27fdcffdbff81f91643ed1fa4123ab4e182491f1101297cb8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV.prepend_path "PATH", Formula["node@20"].bin

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