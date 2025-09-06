class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.3.2.tgz"
  sha256 "f4548a483e80a977a76940ccd80c6111d1c3ebf7a0b25f0e032c5c97690ece30"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "ba56a0ebc08850c8e1f7106a5a453c46756c2cf6e4b1c571674fbfa31cfa8f43"
    sha256                               arm64_sonoma:  "2b042456a6a4fe9619fbdfd5209cd24d9873edd378107a563d737c27e81f53aa"
    sha256                               arm64_ventura: "3874357d1c07cb9507b0a2640afb0aefe0dd68daec2d1b9947e6ee69c825f0cb"
    sha256                               sonoma:        "fb758c97db0493b4c70c5f9325752ffa3058fbcccf290675be93ca731677169d"
    sha256                               ventura:       "8a46fd4eb73278662e060d9b5a87d114d0b967fb2a67fb7c4c5974cb2eaec552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23bf81484850c1c944ffe3c4a3e0dc538586fc5e1651080f0e9fb958e4fa2b72"
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