require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.65.2.tgz"
  sha256 "d3079b2bcc90d9193f8f5cca195c3c23e72767e0a8760d59c408da0220ecd762"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56112c090f4265d0b77cbc8de9113fab8a455f8957b0fd8d2eb658f938b09cba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22e30ecd7b34c5d9ddc8f259548b08fe4ee4434cec1d7ceae083b9f393c48714"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66b9517dfff698d655bb6e64faad66a79f7b801638bdb7715e45445d712431ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d4a4927e2acda033f08eb05765e691397e28077e045c5d21aefa9bd4cbdb4f9"
    sha256 cellar: :any_skip_relocation, ventura:        "c32c216070d476fd12f330d8d12c5d1ddfcf6c488be44c3a22c2f5cec2262ad8"
    sha256 cellar: :any_skip_relocation, monterey:       "556efdc5134e2ecfd77e8a13468929711b1a7da6b97aa90b68fe3caac0b26d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58b15f9a9a68610c6a166cd35ceacef1704b89c9365055b0d2602fbe6e597c3e"
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