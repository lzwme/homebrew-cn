class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.3.1.tgz"
  sha256 "719a4613231f97919a64a55238581e4baf2cf93d643808849a934ec4955ab18e"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "578b374bfae807f5682bafcb238e37f4b78ca0d43a45b73ba00576f5fa085715"
    sha256                               arm64_sonoma:  "d9e5b6655091d9959fd01083f302208be6caccb7ac2017b28ab8b0ca1381e0f0"
    sha256                               arm64_ventura: "a3e5cb5c227cdb68dc9e6344efbe3331a7f8f9547df95632bd5e2d202392ec8d"
    sha256                               sonoma:        "989e134f3b6595f4b469227bd26bd31f27891964f6f8df348d94220b30a7276c"
    sha256                               ventura:       "ebb2bd631bd89cfb57633b3b6368883b9bda1073cba824e11ccb55df70e4bb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "886204970d20fffd28d697e379839b50728a5a2421fb7fa0184bbe0563272537"
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