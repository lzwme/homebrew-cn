class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.101.0.tgz"
  sha256 "2d815142469e5fce774bb3adb716e5f337727fdfe8acba46535bf402c6eb9ee0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17a1378c74d2cc07cfbd907087a3d638df7245214de88e5824d1a0b4123b6e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54efb9eff1209fdd288fbc921b18d027c62a8ed0deccd7c774c59b89a8b9b261"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb6f23866e47e73ed07f34d31bb0a567369fa4bd56beaf40755814d6582c667a"
    sha256 cellar: :any_skip_relocation, sonoma:        "09ad75cc5d042f76538b967362f9285c96b91e91fd90c463af170d45577fe0ea"
    sha256 cellar: :any_skip_relocation, ventura:       "db9920dc613a0a3d6019166e3d37fc673f1988fc18c6172b7261a43a85712854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "358f1ed24a0c64d5de073615e812ab70247f568e82dfb4065eb8450a38ae261f"
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