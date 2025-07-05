class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.1.9.tgz"
  sha256 "0f995b6ecacb8a1059e8f4cca7c89008c8e17563ff67acd523bfe1cfbe8dfb83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc6ed3eeab9a60d50aa5daca2004f8f8b87f4b7d475b8ebd8a3ec02cfc969739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc6ed3eeab9a60d50aa5daca2004f8f8b87f4b7d475b8ebd8a3ec02cfc969739"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc6ed3eeab9a60d50aa5daca2004f8f8b87f4b7d475b8ebd8a3ec02cfc969739"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5e7934bb838b3969bbea653a9ba5fe02571ec72e1f984cb326e1126f92bb6da"
    sha256 cellar: :any_skip_relocation, ventura:       "e5e7934bb838b3969bbea653a9ba5fe02571ec72e1f984cb326e1126f92bb6da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc6ed3eeab9a60d50aa5daca2004f8f8b87f4b7d475b8ebd8a3ec02cfc969739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc6ed3eeab9a60d50aa5daca2004f8f8b87f4b7d475b8ebd8a3ec02cfc969739"
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