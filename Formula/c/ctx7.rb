class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.14.tgz"
  sha256 "67263abb2effd8a9f9ce36c20913270377a7b433cbc2fdd0a0905287dba1c3e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a14b9fe4ac23379e0694d0bcc969b071ef8419c75792868dc153671f9622f40f"
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