class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.0.tgz"
  sha256 "3cd8926e7fa40689d34e667776a4733e16b7ca694364c2d1e02e9e91732d3324"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7ed186b8aae4c101beea78cde21b85eba3b090b5cbca7c777a422096adda0de2"
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