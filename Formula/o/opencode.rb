class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.55.tgz"
  sha256 "1193162c390d75be2fb9372bf16d3ed7f8381099871cc0cabaacfe900e5428b6"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "46522d30877a51badf48f296bc25480d68a80af646c5789c3efc29ce66a666a9"
    sha256                               arm64_sequoia: "46522d30877a51badf48f296bc25480d68a80af646c5789c3efc29ce66a666a9"
    sha256                               arm64_sonoma:  "46522d30877a51badf48f296bc25480d68a80af646c5789c3efc29ce66a666a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "87b83988937a785608bee2ee873e7cff5ddf701aefe335da412e6f46b492bfae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "423f15a5c8d8a2dbaebba3ba07c76dbd1a1b7d4c02916e0c135f125e0dd269ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9d7bfbe88f68506527e1f0794b3a4c5b5caca646e3e8ac61173c75cf439dce3"
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