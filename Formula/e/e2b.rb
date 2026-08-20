class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.16.2.tgz"
  sha256 "612a62ab37e1f76940a894c436589eaff134c17ccaee4f370cff6ebe78afc523"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99efd4e8a23a7bb56c60250eb7129652a2bdf9b89ff46b65794f13e7a5188147"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end