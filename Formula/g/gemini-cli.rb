class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https:github.comgoogle-geminigemini-cli"
  url "https:registry.npmjs.org@googlegemini-cli-gemini-cli-0.1.3.tgz"
  sha256 "c12db51e176e9f1b0f5c329df7596d1099e9193c44c2ef6f3c5b39c0f568a184"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc9cd3d3b48ff2936eef5fad4361ab41659873da9d2b1f03f06bd604d8e85b02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc9cd3d3b48ff2936eef5fad4361ab41659873da9d2b1f03f06bd604d8e85b02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc9cd3d3b48ff2936eef5fad4361ab41659873da9d2b1f03f06bd604d8e85b02"
    sha256 cellar: :any_skip_relocation, sonoma:        "d847e1e47173da79fd069d007e15ac3a10e1107cbc53135e38588e44c6d8e22d"
    sha256 cellar: :any_skip_relocation, ventura:       "d847e1e47173da79fd069d007e15ac3a10e1107cbc53135e38588e44c6d8e22d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc9cd3d3b48ff2936eef5fad4361ab41659873da9d2b1f03f06bd604d8e85b02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9cd3d3b48ff2936eef5fad4361ab41659873da9d2b1f03f06bd604d8e85b02"
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