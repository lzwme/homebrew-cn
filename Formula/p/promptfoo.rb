class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.98.0.tgz"
  sha256 "b97fbd1dc2c5292fe29ec9f2823e6423a44828eded69086e25441a660b3f5ba8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b749876bb7a1922574876bd4b61678e39957570effff26878b2e1d1c9d6271ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb44589dca9176b3540c1b16b012c3447258291deae85fb6de8d09d520311504"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b1b8ec8465056a8fcd8551317554842c0db6ac02046625db1bee8e26877fd40"
    sha256 cellar: :any_skip_relocation, sonoma:        "118c434db045ad8246f73e04147a86a5601ddb1d69fbcf89bcb417d4757e443d"
    sha256 cellar: :any_skip_relocation, ventura:       "45f2a94939b4c424ef80db22c2abfb8a45ab5f6290120c8181b5949974578d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5090f72644c36bbfc2e14960a57859aa9ff28e25a91a1c4b157791ffc0957fcd"
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