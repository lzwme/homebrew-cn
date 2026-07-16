class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-25.0.0.tgz"
  sha256 "f8f72d997b5ba60d02da3c0f49e7c167dc3fbfd86032cd751c9d5fc38a3e624f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf40eb8bebb11943f09da19f5e7c3e3cb411324b776710bd64e7b57d7a533410"
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