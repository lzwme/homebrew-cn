class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.79.0.tgz"
  sha256 "4d60baefba1eb7073fd48f19b846c0a3ca392e433e7ebe4963b77d0a067f5757"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38e414f452cdac91fb63840e0336bfaed2c18368dd33561042167342f5c1af4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71a58be647ca61ab839a3f9848120cfaa5e8201b25bd005f37deae34e478ec22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e64e80c7efc8e55314dd4d47805d40e4c0f28d9286b0d49999cd377e2b3694f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "37c6a1e04a06e48ee9d4f8f310bd69d21afe8d62995be1a111f5709c5cfd1438"
    sha256 cellar: :any_skip_relocation, ventura:        "36ada670bfe5c6aa2a81c58aa4d44b1162ac63f0cb1aa53bca05ea81a8fb20de"
    sha256 cellar: :any_skip_relocation, monterey:       "9413373b81a062cbde6a84340208f0ee11da9ff173995792b00d6bafe0f3a187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819f5059ccf1bd0912c597873ef2e998bfa28174d4c8298bdfcb860e7f70e9a3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end