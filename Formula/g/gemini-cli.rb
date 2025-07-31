class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.15.tgz"
  sha256 "414a5d0fc16c4c3f08dec8ad97e2d887254008fa4fdd2bc3aa32122329eb7879"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc2386ad2883e06a120d66c5989c3c3ce9624be2921761194836c303a8ea5529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc2386ad2883e06a120d66c5989c3c3ce9624be2921761194836c303a8ea5529"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc2386ad2883e06a120d66c5989c3c3ce9624be2921761194836c303a8ea5529"
    sha256 cellar: :any_skip_relocation, sonoma:        "601a0660ea3d7f809319d77193cc3dc22249270a94a34eb65699c2bd0766a1a1"
    sha256 cellar: :any_skip_relocation, ventura:       "601a0660ea3d7f809319d77193cc3dc22249270a94a34eb65699c2bd0766a1a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc2386ad2883e06a120d66c5989c3c3ce9624be2921761194836c303a8ea5529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2386ad2883e06a120d66c5989c3c3ce9624be2921761194836c303a8ea5529"
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