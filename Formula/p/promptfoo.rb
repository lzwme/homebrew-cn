class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.90.3.tgz"
  sha256 "ab989a2b2cf8df7430216d66c16387a06d89304ff5ec40afdd6fe053381fb449"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e218e620c100009f667aa86a2aa964045413aedbc5de7860b92f4fdde75cb96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "335ada4541d204bd3bb3faea7886c4614ff1d9ca0ed421d594fea6fdb49a642e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be71860777d20d6fe5a0d68cc358c7298f87ba7fb1faee273435e3cc4462b717"
    sha256 cellar: :any_skip_relocation, sonoma:        "274fa8e2f43c1a47d6f1577275a00b0dbdf06f19ea82881c53dda158636a50f3"
    sha256 cellar: :any_skip_relocation, ventura:       "fed71d92105c7f6d526b05ecfe1e32880eefed3e3bb1209c6d1db2ba97dfb236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8da30ef6edabe11acd1f6a63c453747a44b30b5eca24554f5f6632a69c94b7d1"
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