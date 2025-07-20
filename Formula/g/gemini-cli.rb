class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.13.tgz"
  sha256 "6f599f49d64913fe0bcdbe869f5d64c82141583aa26e6144ae94190114528821"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e124354c011b9dc94e5bc584545242d370254c489e1565789101d7b0efb702ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e124354c011b9dc94e5bc584545242d370254c489e1565789101d7b0efb702ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e124354c011b9dc94e5bc584545242d370254c489e1565789101d7b0efb702ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "29e340c208fe2421316675e98a92b315f98b8c97ca92a3eb22a79a8a4c39005a"
    sha256 cellar: :any_skip_relocation, ventura:       "29e340c208fe2421316675e98a92b315f98b8c97ca92a3eb22a79a8a4c39005a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e124354c011b9dc94e5bc584545242d370254c489e1565789101d7b0efb702ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e124354c011b9dc94e5bc584545242d370254c489e1565789101d7b0efb702ee"
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