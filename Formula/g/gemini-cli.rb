class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.2.1.tgz"
  sha256 "1f65bf1b9e125dc610168cfae417e245b41268f869b0cdf0734c830079d53c1f"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "126f64d6d0352020932cc6f64b427df3ca75a5884e0137b8b179ed4829b37511"
    sha256                               arm64_sonoma:  "4f0580d95d778fe74641ab91f33826eae5ec14f9de2590ff41dc2c58900ee3fc"
    sha256                               arm64_ventura: "cc6cedfe97f608ad0ca4b27e066fdb186bd9687980d72bd1de8222aa1b1e4e18"
    sha256                               sonoma:        "8ed160b45e1671d5857d5ad6275763b69a8b917f9d954cf13dca1ef0e68fa260"
    sha256                               ventura:       "202e5aadcd7e18ef6dad30b4573a4f148f79a59d1e0468004e221c8074a378df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "616a3da281592e75415706cc44256986357f65f3a2247e1070b2c6707bee1fb3"
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