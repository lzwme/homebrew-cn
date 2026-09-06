class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.23.0.tgz"
  sha256 "3c0cba7631561670c4008c95a8b2034e499f8564f25a9d089718dcb66722337a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fe971c91401db3ecf794357d1e3aea6cf7f6c61f007bb681d7e6574a4a06712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fe971c91401db3ecf794357d1e3aea6cf7f6c61f007bb681d7e6574a4a06712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fe971c91401db3ecf794357d1e3aea6cf7f6c61f007bb681d7e6574a4a06712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad102958cffd1bdff913cbb3f5003cc408c7223bf287ef22c11940f3d75d4d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad102958cffd1bdff913cbb3f5003cc408c7223bf287ef22c11940f3d75d4d89"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end