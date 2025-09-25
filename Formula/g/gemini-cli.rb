class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.6.0.tgz"
  sha256 "3cd5b6f462f0ef108421530e9d9eed92f0d557fb2ff2d6712845b8f0cbbd2c18"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "250a30ea92d402c4a7bafe750f9289b7923402c4593519c3128176ecf95d1e8d"
    sha256                               arm64_sequoia: "ba854754f66a2efaf56e9dd609ff85ece429e27cb7881f51fb082c0ab6b1bb6a"
    sha256                               arm64_sonoma:  "daa9b852feb25c6ca91e85c8213679764ec4d1f20f31e200a78f95d4a7965c80"
    sha256                               sonoma:        "52b6d6d7441907b4f508dd4e54df35f0618475486064f5af505539bdfa8da6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f18478c82db20fd5df4ebadd79f8993875d316a9bbf61b9b829284b9b40573ae"
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