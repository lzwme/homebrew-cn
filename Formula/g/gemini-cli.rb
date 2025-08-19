class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.22.tgz"
  sha256 "e62d207a949175f9044146bd7bdc4a7d2926265ab07b86901aca77c79bf5bfd8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "466fe65c91f7314305ec774520f08ff1958d35968fa41f174b41ea6a1219db39"
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