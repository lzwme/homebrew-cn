class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https:github.comgoogle-geminigemini-cli"
  url "https:registry.npmjs.org@googlegemini-cli-gemini-cli-0.1.6.tgz"
  sha256 "71af3ab422d5a61bdf260cb01778cf9179c796ed8d95fa3e085b0047e4efee7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a68e585e4a6a352d13f6677b6a8b7b48dd5afb102cb075cd1ed52e71010584a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68e585e4a6a352d13f6677b6a8b7b48dd5afb102cb075cd1ed52e71010584a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a68e585e4a6a352d13f6677b6a8b7b48dd5afb102cb075cd1ed52e71010584a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "29972b7aa6799c97e3facba67990df19b5f6c964c899ce469b4249968c6182f8"
    sha256 cellar: :any_skip_relocation, ventura:       "29972b7aa6799c97e3facba67990df19b5f6c964c899ce469b4249968c6182f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a68e585e4a6a352d13f6677b6a8b7b48dd5afb102cb075cd1ed52e71010584a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a68e585e4a6a352d13f6677b6a8b7b48dd5afb102cb075cd1ed52e71010584a8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}gemini --prompt Homebrew 2>&1", 1)
  end
end