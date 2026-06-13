class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.2.tgz"
  sha256 "12fb886cafde8b9d965a5214b0d5182a626e9e89738999c3456766409b00084d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90bdd3e2d000692f500fe85ad71019c8e2dd31cb0e41dd5aa4e16e851b41b370"
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