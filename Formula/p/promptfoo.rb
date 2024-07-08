require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.69.1.tgz"
  sha256 "a8a7117f5cbe3ab2c0a35c24283f2d5c8eba98ce01c50356035a40df99ee10dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e835f2d06951ce28041fb66ba266dfbc011d24a7c505d9bcf5ad420e0c3e7fcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94802e827a7bd6ea8b5763e892c18b4a620e6c2afe88bfa3ffe3c367e8df8e4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "961eafe1b51b9c22ce8373c68f72fff9c721c35bf20bcb75fd614428a4d5f9c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6951475025c4f83a6d3073fcc17997c5b16f2c117e82212f20d6d493c1b87e0c"
    sha256 cellar: :any_skip_relocation, ventura:        "5e24d2cc94fe1f1b3b490b07de685f9994cdaf03a8446007cb425f586a4fd939"
    sha256 cellar: :any_skip_relocation, monterey:       "c70e0e4528bad82d818f86a1267ed43ee80dc726b23066c8de0bf561ccc79ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3754f2231c72c10ea08fcca1ef8fb7b6f75b380d5cb51712263aab547ce7de99"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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