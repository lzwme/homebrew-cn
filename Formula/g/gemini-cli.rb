class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.11.tgz"
  sha256 "1cee4750c7f3dc1ebaace75b93b577de21087b470af66411bb38a90f87b5309e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3442bc7c4e545c018d586b5a18c484110d5ef52ae2cd43e9aacb23be3a53de1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3442bc7c4e545c018d586b5a18c484110d5ef52ae2cd43e9aacb23be3a53de1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3442bc7c4e545c018d586b5a18c484110d5ef52ae2cd43e9aacb23be3a53de1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a9ea5a1e8c54750fbc391aaf3d21aa93c0ad68084c6197ad7f861f4205d0e16"
    sha256 cellar: :any_skip_relocation, ventura:       "6a9ea5a1e8c54750fbc391aaf3d21aa93c0ad68084c6197ad7f861f4205d0e16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3442bc7c4e545c018d586b5a18c484110d5ef52ae2cd43e9aacb23be3a53de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3442bc7c4e545c018d586b5a18c484110d5ef52ae2cd43e9aacb23be3a53de1"
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