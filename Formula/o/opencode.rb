class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.28.tgz"
  sha256 "a1162a3d723dbcb8f9353fc8b718bc85d5e255b59493bee4d8035a02f9ab6fb6"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "6eb49046eafd0182e8d062f90d4f02b0e196406210552905799cb4a128b487b7"
    sha256                               arm64_sequoia: "6eb49046eafd0182e8d062f90d4f02b0e196406210552905799cb4a128b487b7"
    sha256                               arm64_sonoma:  "6eb49046eafd0182e8d062f90d4f02b0e196406210552905799cb4a128b487b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "217b2a6a6488d49bd691e3a6df8ec78895188ccd1167c8a1869acb0626408df1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8be29f5f1bf6dae900057f91a50a119303e4b7290e99dc2046d78cc8e80b3581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd74ff594a4f7bb2059f3adde0a3f73ebbafeac6212e932af816688ab1bd8256"
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