class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https:github.comopenaicodex"
  url "https:registry.npmjs.org@openaicodex-codex-0.1.2505021246.tgz"
  sha256 "70d27f89af3eb9d2697de0a9ba68564d32fc6faecb6f8dfcd2cca7e6ab919ab8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85df5edd03aa3806252b9868d83ca32cba01d252889970f77bbc020c37933d9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85df5edd03aa3806252b9868d83ca32cba01d252889970f77bbc020c37933d9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85df5edd03aa3806252b9868d83ca32cba01d252889970f77bbc020c37933d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c0511f07c5d8b0ee0d5bd810f802fafe569a9b002590afa8e2452bdced54c37"
    sha256 cellar: :any_skip_relocation, ventura:       "9c0511f07c5d8b0ee0d5bd810f802fafe569a9b002590afa8e2452bdced54c37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85df5edd03aa3806252b9868d83ca32cba01d252889970f77bbc020c37933d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85df5edd03aa3806252b9868d83ca32cba01d252889970f77bbc020c37933d9d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    generate_completions_from_executable(bin"codex", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}codex --version")

    assert_match "Missing openai API key", shell_output("#{bin}codex brew 2>&1", 1)
  end
end