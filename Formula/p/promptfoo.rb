class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.95.0.tgz"
  sha256 "473b53ce88526cc087fa5b46fcacab6ca0d3b0699f7ec12c8722b1c6402b83b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "234d1440ff26bbf936240d4add7d85b8c2eff79421deac4f9ca109dd0286c6b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b9a1caa523ce34bfa6f1d037f76d6bf99f971c0a6a6c2849ed61392f013fc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bf8b37f777d128e718a55399338aed9bd5d809fae3ac4cfc078dc32a5f6128a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f2e1233e934024924f708ca1a7c1f7292f86c477972f8c55eb9b05579602957"
    sha256 cellar: :any_skip_relocation, ventura:       "569bebf342ef50905d2b17aa643c8f6c04cd0c3ba30f0bc75b6e09ac1d522624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc074976854b02e6d4513a1f7d374a081bfe2bed3f201e021d02cfa4844c460"
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