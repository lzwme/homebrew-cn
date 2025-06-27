class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https:github.comgoogle-geminigemini-cli"
  url "https:registry.npmjs.org@googlegemini-cli-gemini-cli-0.1.4.tgz"
  sha256 "400eb9b5cb8ec71c8a391444b5412882001d7fa3aedff3911ad0f8145110fca0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf4bec5a38f77f93d6ca69e925873371f149842c61c56a35d29c57ba1a6b04f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf4bec5a38f77f93d6ca69e925873371f149842c61c56a35d29c57ba1a6b04f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf4bec5a38f77f93d6ca69e925873371f149842c61c56a35d29c57ba1a6b04f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "340cb4b31b8d78dd5706e4663e2498a3cbf0000b4c436cb9f53e1b35a4fcbe89"
    sha256 cellar: :any_skip_relocation, ventura:       "340cb4b31b8d78dd5706e4663e2498a3cbf0000b4c436cb9f53e1b35a4fcbe89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf4bec5a38f77f93d6ca69e925873371f149842c61c56a35d29c57ba1a6b04f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf4bec5a38f77f93d6ca69e925873371f149842c61c56a35d29c57ba1a6b04f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}gemini --prompt Homebrew 2>&1", 1)
  end
end