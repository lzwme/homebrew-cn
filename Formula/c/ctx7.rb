class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.4.5.tgz"
  sha256 "aa1adcc7c06d1bc8c5763a793bfbf533faec699f826088698df380648c680fb3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "437455771da60e981d0bc55c486ed9ff9ff7356a0e1e1d36a4172ad504414182"
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