class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.8.0.tgz"
  sha256 "b270ce72e33f45dbc2ef99dea50b207cf51137ef02b4e5c578bd943546e6d694"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "e1c41a9f3d639f67258d1baf2f3a7fb2e53663e2e969b0f24083fdf0f38373e2"
    sha256                               arm64_sequoia: "3216d6741c85edbcd01a538ce4056d64b164ce77d1b37e809f2c3aaa6a428438"
    sha256                               arm64_sonoma:  "dba25319f00e0f7d30e8d851923a668c5fdda1837825b3d36a7918300f92f699"
    sha256                               sonoma:        "34fb16c07c0a63935c5991a0ad7e9c6c96c0a72f363157a055303f087aed7671"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dc8c77718aae9987cad28ec8bb1a4c59a49d907982606e2ab2e226f7fb4de01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95726068b170a2a8fa0a19f8f690a5d4a20051e5a4b3c5f9fd97f2038b0b58dd"
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