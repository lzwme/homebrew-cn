class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https:github.comopenaicodex"
  url "https:registry.npmjs.org@openaicodex-codex-0.1.2505141022.tgz"
  sha256 "56548be82188742828bdce9721fe5e046740da9552d8f145404fb44e239e00b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6afc64bfb2b3f614ee89921cb4f06f625b4b8c7f02740a77fab9d3a2cc2b34c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6afc64bfb2b3f614ee89921cb4f06f625b4b8c7f02740a77fab9d3a2cc2b34c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6afc64bfb2b3f614ee89921cb4f06f625b4b8c7f02740a77fab9d3a2cc2b34c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6179ec361d37813db5c0f668bc5fca20a8dc297b8df056b3c53d5cedc018aba"
    sha256 cellar: :any_skip_relocation, ventura:       "d6179ec361d37813db5c0f668bc5fca20a8dc297b8df056b3c53d5cedc018aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6afc64bfb2b3f614ee89921cb4f06f625b4b8c7f02740a77fab9d3a2cc2b34c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6afc64bfb2b3f614ee89921cb4f06f625b4b8c7f02740a77fab9d3a2cc2b34c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    libexec.glob("libnode_modules@openaicodexbin*")
           .each { |f| rm_r(f) if f.extname != ".js" }

    generate_completions_from_executable(bin"codex", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}codex --version")

    assert_match "Missing openai API key", shell_output("#{bin}codex brew 2>&1", 1)
  end
end