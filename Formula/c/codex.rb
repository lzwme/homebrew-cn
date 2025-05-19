class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https:github.comopenaicodex"
  url "https:registry.npmjs.org@openaicodex-codex-0.1.2505172129.tgz"
  sha256 "854213e2de7ac64a2611217a7ab5c7e349d35fe0a10062ea689796ba84309fbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52d7b27ebeb2e79e2d140c0cf3238f69e191a75ec216a34c7babb7cc5a3cf0da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52d7b27ebeb2e79e2d140c0cf3238f69e191a75ec216a34c7babb7cc5a3cf0da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52d7b27ebeb2e79e2d140c0cf3238f69e191a75ec216a34c7babb7cc5a3cf0da"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e21a7453300d3f9fb8aad12452427412e059d465516df3bc3b69e15105c0163"
    sha256 cellar: :any_skip_relocation, ventura:       "1e21a7453300d3f9fb8aad12452427412e059d465516df3bc3b69e15105c0163"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52d7b27ebeb2e79e2d140c0cf3238f69e191a75ec216a34c7babb7cc5a3cf0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52d7b27ebeb2e79e2d140c0cf3238f69e191a75ec216a34c7babb7cc5a3cf0da"
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
    # codex is a TUI application
    assert_match version.to_s, shell_output("#{bin}codex --version")
  end
end