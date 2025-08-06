class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.17.tgz"
  sha256 "e80552bbc4ce4f134f0bbb0cfd1f2497ed973976b23ef081ff4adfc951242d95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c758aed35b11f82e366de6354adc2312846023cfcfa342a97be51f4801523a0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c758aed35b11f82e366de6354adc2312846023cfcfa342a97be51f4801523a0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c758aed35b11f82e366de6354adc2312846023cfcfa342a97be51f4801523a0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "66bb6c33c6bff9321bcb2ff70665fbcf7f22dd9753c1efff347d70fe8d36b85a"
    sha256 cellar: :any_skip_relocation, ventura:       "66bb6c33c6bff9321bcb2ff70665fbcf7f22dd9753c1efff347d70fe8d36b85a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c758aed35b11f82e366de6354adc2312846023cfcfa342a97be51f4801523a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c758aed35b11f82e366de6354adc2312846023cfcfa342a97be51f4801523a0c"
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