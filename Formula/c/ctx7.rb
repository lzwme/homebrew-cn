class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.8.2.tgz"
  sha256 "302c372c8e52984f0b9df3746d635d142ba0512881668819b80c88e94f21b61b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "184bec30aa9dadc09c9dfbc45eea37b3fda6bc7c261ed02e7481e0da974ec20c"
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