require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.59.tgz"
  sha256 "9907d3d59b1fe20f49aef18e0186743d94436c85bc21cfabe6ecc512a38d5c3a"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "949a08b1cf25d6811e290638edb42d3761071be5be6117945f667d90635a7f0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "949a08b1cf25d6811e290638edb42d3761071be5be6117945f667d90635a7f0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "949a08b1cf25d6811e290638edb42d3761071be5be6117945f667d90635a7f0f"
    sha256 cellar: :any_skip_relocation, ventura:        "04b9b67e1d340bb6421fa15daff3f6217ed96a28b19709cdfd418623b689ecea"
    sha256 cellar: :any_skip_relocation, monterey:       "04b9b67e1d340bb6421fa15daff3f6217ed96a28b19709cdfd418623b689ecea"
    sha256 cellar: :any_skip_relocation, big_sur:        "04b9b67e1d340bb6421fa15daff3f6217ed96a28b19709cdfd418623b689ecea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "949a08b1cf25d6811e290638edb42d3761071be5be6117945f667d90635a7f0f"
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