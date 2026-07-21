class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-25.1.0.tgz"
  sha256 "914fcddc444479a6ee5119fa19dda4e38eaadbb173c9d3acf1dd9b295a8f1670"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fbdd45c5c6d7d4e2e913c20053cb5f6168317efd325a6a6632be50ec7cec4ece"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    JSON
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end