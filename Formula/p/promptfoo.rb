class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.107.2.tgz"
  sha256 "e66b279f323323ac5fd730f36572e85d29f68d434780e51d4cc799530e4ef127"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62231fc903f3f58d56feb77bf936de6f33ad8f14989015d01befe52b4bcfaaa7"
    sha256 cellar: :any,                 arm64_sonoma:  "b8022d82d7ce4be93bc610706f9d84133ebe22bb776dab11ce20a9559c22c4cc"
    sha256 cellar: :any,                 arm64_ventura: "4d701b275e788a328ffb3db623d5f8c375295663368ad1fe2902e35d6ae3566e"
    sha256                               sonoma:        "619e19acf7cbb0c1fda629ce4f8aea6dd284f65c5e8cc8f03fddf047c85c1848"
    sha256                               ventura:       "0c5f3ad3cff1f27f1fa308862d5e1cdba5a44993dd9826d944ffbcf4762c7a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c3080f9ffebfd7fbdd76ba44481de7b39e641d9a280187815e048e38ee783d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end