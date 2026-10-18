class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.8.0.tgz"
  sha256 "15da7f0f2e99f75afaba571ac9de0d5ab7c640885c6638b3a3d99ae91b923d5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19a9fe795115a18441f8313259ed253fc096d310900e1838fb68d8013ff0183a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx7 --version")
    assert_match "Not logged in", shell_output("#{bin}/ctx7 whoami")
    system bin/"ctx7", "library", "react", "hooks"
  end
end