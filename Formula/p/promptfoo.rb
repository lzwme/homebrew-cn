require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.65.0.tgz"
  sha256 "97d4bc0138bda8fd6f7eee721cebf080cbe2a6cb2ae90f10da1774a1c82c7630"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0974801f05719087bfccc68d6cf5e490266d05e907e9593e6d9afd56c5e8b12e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c428c9275da86cd2c6b1039376bfbcbdedb698e824dfe73ce5f6feeac193721c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "353cd15b7f72ec9afc873781b373af1b830434fe7ef886f40ec08bdf832551dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "010bec74e811b87b4ee511d22002f8a1cf191372483ec66dfa09bb57a4d19393"
    sha256 cellar: :any_skip_relocation, ventura:        "f10dd0846fb4755bf980ba5a8d53ec89124986c2f6e2738f089a8da59a351d8e"
    sha256 cellar: :any_skip_relocation, monterey:       "8415a4594f3684abfcb8dbcf08c7769be700cd60ae3406f5f14fb284fa5fabc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3e949a75f004cd12a3c2c0e2805bb0d8d291be4b9080f746254ccd3703ee510"
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