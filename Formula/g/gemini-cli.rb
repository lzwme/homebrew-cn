class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.14.tgz"
  sha256 "bc1261732509b28226e3c5e94e6c33ca2e48251642f5bb8b2a685079ce39ac13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33b9b86707c974f92ee17947ab776702ee257e724d91c2199a09c804241b6962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33b9b86707c974f92ee17947ab776702ee257e724d91c2199a09c804241b6962"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33b9b86707c974f92ee17947ab776702ee257e724d91c2199a09c804241b6962"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb97f839e3825edbffb56a7e976f6859fe5021362e4b1db86fc8b09dbaa89cb9"
    sha256 cellar: :any_skip_relocation, ventura:       "eb97f839e3825edbffb56a7e976f6859fe5021362e4b1db86fc8b09dbaa89cb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33b9b86707c974f92ee17947ab776702ee257e724d91c2199a09c804241b6962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b9b86707c974f92ee17947ab776702ee257e724d91c2199a09c804241b6962"
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