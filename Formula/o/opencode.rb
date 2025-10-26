class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.17.tgz"
  sha256 "081d59aef4db9522dcacdd1e1a0c16d5d0fc27216cea72e5806ee1c2d8e0dcca"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a5c253fa857e466de8d37c24627ed33883cb544212ae59e5d4e8df9c66c77e8a"
    sha256                               arm64_sequoia: "a5c253fa857e466de8d37c24627ed33883cb544212ae59e5d4e8df9c66c77e8a"
    sha256                               arm64_sonoma:  "a5c253fa857e466de8d37c24627ed33883cb544212ae59e5d4e8df9c66c77e8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a60bc9f130542a5f701b22e46bc9522f203d30c4259373b973e56beb2a89704d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ba0336f56b88a811f92bf78c218a1e454ba0050b1c551e21f389611ba0a5cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab9f2905443fec05e62f5830a389d16d245616fe5ef438e1410e2f420969c4b6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end