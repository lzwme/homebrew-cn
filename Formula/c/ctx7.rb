class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.10.tgz"
  sha256 "0bf487b0a419dad74463343e18c73ab3b9257f887146d4549c22fc1a2264dd1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "807867632af3bda3932112bff23f6ad72e80667f81ad6a9a71709157c37c806b"
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