class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.6.1.tgz"
  sha256 "9716fd758cbe4d6b9b182764c8caebb2beadcd27b63f90d304b6cbef91baf7fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55e8565b5d28b5327a3005a17b72b71d9380c7af98713f8c4d894d6ecd92adc5"
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