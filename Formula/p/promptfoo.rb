require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.1.tgz"
  sha256 "02a9ef57318d0229099f3eb01ed527962983fcf0d6a6d3883c6548f84db9ee4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9accdc2da9850d986972bf80d5fa16f804863a850035b624bc246b1b005c6816"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bd3ee4b51b1cb5cab54e83f5f831ab62505566b624755ae0869cd25a20e3385"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ae4f9ed5b351573fc3c030d54fec521345d213a1f9119479f081ff342fbafcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "664bad1894a71b2d01123821fbe40476ac8be4cd161b8d9ed4fcdd9d84d8bd37"
    sha256 cellar: :any_skip_relocation, ventura:        "a8192bcb3db2d61e8c81a4b43fcb96f0b40253e41d0848442e6688813c4dd432"
    sha256 cellar: :any_skip_relocation, monterey:       "e7952532942c0f2323a58a832a9971d32a791421b13c96991f3db98bd581dd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90fe014882df0835c0e803a0f0d455e194a8f822a87ab62486b0eb89b4298505"
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