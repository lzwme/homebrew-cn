class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.102.1.tgz"
  sha256 "560a005be4d8f321f0027ce25af44f9b982728f217c1a7433ca351f2975ac254"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4579f13a5a254a7219e9d205e45fd9daa21b70bfb6fa642b50c0c51c383e95ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55045540237350c667ce12c5834e0fb165156056fac81eb5d195ae9cc6279a13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d127e68b94b588262adaa74e22f681c2115bc0e1e91bf990c12193c4516c6ab6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4acefd0f3485861c2ee6e8f835a8230bad56098bdd279082d5054e0c774d2942"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b82da8373c2ebc4f7c95d05c9b21d252848e27f82cf971239bf65f2ee22bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddc580d294984d133a93b2fb759564a90ec65c4ede4df8d6d96cf42a3e72768d"
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