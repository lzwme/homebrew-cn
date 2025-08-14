class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.20.tgz"
  sha256 "d1968a975b77b13def7e43d9f194fd23fc8f2164ab2cb2a53245d62ceadb462d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05774b0b68bc79b48038b69c90ae5afdfe91343578a127af7ef4e652f1ab4fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05774b0b68bc79b48038b69c90ae5afdfe91343578a127af7ef4e652f1ab4fb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05774b0b68bc79b48038b69c90ae5afdfe91343578a127af7ef4e652f1ab4fb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e63651ec3fc9cf5ac24f34f4e31d9d6aafd005c364630567c3821b262b338fe0"
    sha256 cellar: :any_skip_relocation, ventura:       "e63651ec3fc9cf5ac24f34f4e31d9d6aafd005c364630567c3821b262b338fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05774b0b68bc79b48038b69c90ae5afdfe91343578a127af7ef4e652f1ab4fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05774b0b68bc79b48038b69c90ae5afdfe91343578a127af7ef4e652f1ab4fb4"
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