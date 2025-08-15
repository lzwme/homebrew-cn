class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.21.tgz"
  sha256 "1c1414cc5396c5d1d2bb793b6b661357d7a96901bdf91cfd327599786f094059"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79b544ee33c02719591cfe405398873b937516a907bbf7b767a88080579a2487"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end