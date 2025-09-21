class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.10.4.tgz"
  sha256 "00ad049125d1bfa8d995ba839d4223777747121662eb04354cec36f1a101b8d4"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3f88c90cbcee418d9c2f858dc1b8aba8b8df9c22ad3d28582d6f78329f6579b8"
    sha256                               arm64_sequoia: "3f88c90cbcee418d9c2f858dc1b8aba8b8df9c22ad3d28582d6f78329f6579b8"
    sha256                               arm64_sonoma:  "3f88c90cbcee418d9c2f858dc1b8aba8b8df9c22ad3d28582d6f78329f6579b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2efd25621040869ec60bd983c913a38b7cc8c2427dcb5f93b2b814a95e979d9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ee345b91173a85f9ed424e6beb3c06096918c234e29b4ff1089c25c13f08c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b958083c861fe4724a43419766863f643183c18caafa3d93e2b97d9c7ed8bf05"
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