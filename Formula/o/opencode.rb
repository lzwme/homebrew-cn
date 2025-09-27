class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.12.1.tgz"
  sha256 "b3f542c7a0b47589627f6172236a73f4b8e379cda8b05c8484cb2ae22b7498df"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a65740b9ab1f41f6d38536327e440d3eed4cef5d4494c7ff2977011de5fc2465"
    sha256                               arm64_sequoia: "a65740b9ab1f41f6d38536327e440d3eed4cef5d4494c7ff2977011de5fc2465"
    sha256                               arm64_sonoma:  "a65740b9ab1f41f6d38536327e440d3eed4cef5d4494c7ff2977011de5fc2465"
    sha256 cellar: :any_skip_relocation, sonoma:        "be30675f2482d41b86e54952e3d21b8a27ba145a165e9a377a59d952d8f6a149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "817018d262023bbef1b8b05a9218c6d32e379df396c19d9aeb22868de9bf235c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cdc6d809174c22b099fe3fc3354ef620547f9592f098644ab5ff80e970c8ea6"
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