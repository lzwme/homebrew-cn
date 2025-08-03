class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.16.tgz"
  sha256 "0e5af520f911f2bd41c856b019021960c3aae34143e99611e825f75d1d247511"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b46f6dd3d19add6e8e4d3bbc2fc96d8a8bab70b873f00758e7dec8ef5377fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b46f6dd3d19add6e8e4d3bbc2fc96d8a8bab70b873f00758e7dec8ef5377fe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b46f6dd3d19add6e8e4d3bbc2fc96d8a8bab70b873f00758e7dec8ef5377fe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ae24e1cda31851154661cfa46652fbc7f88b9d9a8eabc6294a83205d18ce49c"
    sha256 cellar: :any_skip_relocation, ventura:       "1ae24e1cda31851154661cfa46652fbc7f88b9d9a8eabc6294a83205d18ce49c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b46f6dd3d19add6e8e4d3bbc2fc96d8a8bab70b873f00758e7dec8ef5377fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b46f6dd3d19add6e8e4d3bbc2fc96d8a8bab70b873f00758e7dec8ef5377fe5"
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