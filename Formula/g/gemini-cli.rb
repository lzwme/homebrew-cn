class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.19.tgz"
  sha256 "be0149bf0808d0ff3f6c8268bda0e4f083aab53f8c8d62d06f89cf15799c2532"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38e81ff5c7a590b1ae3b735fad04d461194621ad4c8e9cc052e98f97d2ecb771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38e81ff5c7a590b1ae3b735fad04d461194621ad4c8e9cc052e98f97d2ecb771"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38e81ff5c7a590b1ae3b735fad04d461194621ad4c8e9cc052e98f97d2ecb771"
    sha256 cellar: :any_skip_relocation, sonoma:        "e503c19b380401de7f1a311cd76c0ce737ab2fe0e6748b895d383e5e9a2299d9"
    sha256 cellar: :any_skip_relocation, ventura:       "e503c19b380401de7f1a311cd76c0ce737ab2fe0e6748b895d383e5e9a2299d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38e81ff5c7a590b1ae3b735fad04d461194621ad4c8e9cc052e98f97d2ecb771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38e81ff5c7a590b1ae3b735fad04d461194621ad4c8e9cc052e98f97d2ecb771"
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