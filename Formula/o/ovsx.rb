class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-1.0.1.tgz"
  sha256 "1151c8c77731e5222adad48cf3fc812f20a5086f90f7540821ffe8fa8613bec2"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "82e50b55ff12c318186ce50cebc3c75803aefd12d9ab90389ace62b91dc5830f"
    sha256 cellar: :any, arm64_sequoia: "fe3fb2a75d87beafefe48da59951b31f69ae21c2c484b48da12771fc2c874639"
    sha256 cellar: :any, arm64_sonoma:  "fe3fb2a75d87beafefe48da59951b31f69ae21c2c484b48da12771fc2c874639"
    sha256 cellar: :any, sonoma:        "cc844dd1ecdd02cce038bc20d8ccb6bee2eb0955e412e6cfde2b69d09a7cff22"
    sha256 cellar: :any, arm64_linux:   "0990367b193508b6aa52cf6be66ea41a52a77080d1a0532f5d0f68d7cbf27a25"
    sha256 cellar: :any, x86_64_linux:  "5f943addf1484d55001131d183c163d2a6d4201c5857f771c70eceb7657c1cae"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end