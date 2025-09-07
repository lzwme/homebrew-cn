class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.3.4.tgz"
  sha256 "495f6c496afc358f8f6bdec791b5cde1f99ef7901319798f2da2c37562ded260"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "1c7eaf31537f0e3e590aaf87a3e13d290747d01821e3a1f57fc23cc66cdd8ca1"
    sha256                               arm64_sonoma:  "bd33677e2489e70e0bc3e99255be98b30fef83258a0647802bd4a9f0106f11de"
    sha256                               arm64_ventura: "64df5103c4b9b934418366f8241464c3fe00c1347676407fff4ec142480cb103"
    sha256                               sonoma:        "1f6dba1c52acaa189ccc598e93b8a8c637f41e7fb70420b79918e7883c4d917e"
    sha256                               ventura:       "48bd43b07e55e070cb7930098cbb17181cb4f6a296aaff2764898e02aa6e0251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c15625d995b5c7265872fc529f233daf94e87216cc47662a54557d6df0bc25"
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