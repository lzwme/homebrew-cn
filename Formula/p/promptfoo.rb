require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.63.2.tgz"
  sha256 "d43ad27b4be507f45ced001bcc35c958dea779ce36822539b3a5758dcce2093c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ae2866c26603e6aafd7310d28113a44271d9370d30e3199b4131f5ea4ef1bcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b87998ee48ba69a862fa7e48026ba6648bcaf136296f4d27e8ff219e60285a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fac20d0a28a09afeabfe32e069f0a9e6e8e5fb00ae66209eaa31a570527a0cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "31fff2331dc1284bc0c72646caeacdcce6474a8c8d0299b81288f04258ab9da6"
    sha256 cellar: :any_skip_relocation, ventura:        "3eaaa56e5aa06de58c7ab867deffc10fe84343300454c065d8b52d8ab983bd24"
    sha256 cellar: :any_skip_relocation, monterey:       "e8253abf13f092752ae37f47ad22d9a9925eb8aeef2d4be47ec105944456bed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c500f5a4b85a7af0dfa81663883c3beb7fab64f44ec1f0f95fec8d59688899c1"
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
    assert_match "description: 'My eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end