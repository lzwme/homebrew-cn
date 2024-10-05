class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.91.3.tgz"
  sha256 "48ec669ac453db51b746de779e51c287514cb797e81611f2d67b5afbe36b5a57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a17dc0f21b38fc674c77fe1737c169ff1bb167748c2492fae797f763e8626e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d436fc96a50876b24d39e9a64c5eb68304fac1c8121feb83e2f7cacf6f6f400"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebd9c5ed34d0777cfdfb4792fb904ed5e77347807533a770eaad9be5c6095c50"
    sha256 cellar: :any_skip_relocation, sonoma:        "d49ab499a2dac99147f1bd324cd66426ff4736a1c3cd3210388d55a7f3b4cbfd"
    sha256 cellar: :any_skip_relocation, ventura:       "85924eead80b177164ad614ce6916fe0fa065a5b3b3e864f6eeb0de89187d5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46ff97c7f61cf6e65042fb8305443dfffe6c0ca2619aa7a4aa6da0551c9d698"
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