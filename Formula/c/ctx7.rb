class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.4.3.tgz"
  sha256 "0deaee191595e7f66cecf9526d403be5e0a1b81c6101fb769773d506bc33e9f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b12cb0572b36ddf1bf0980b529c9d7c17bdcf091aca54f6cfa1c1a671c2a999"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx7 --version")
    assert_match "Not logged in", shell_output("#{bin}/ctx7 whoami")
    assert_match "No skills installed", shell_output("#{bin}/ctx7 skills list")
    system bin/"ctx7", "library", "react", "hooks"
  end
end