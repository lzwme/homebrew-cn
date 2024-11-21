class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1294.1.tgz"
  sha256 "78fd64755f676aa394a43208a8e760636e19f803f73a54dd0c6ddbab48155002"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27039ac658a9bc751ac0459a4241b0fdc8a9e9f272f739585308814a8075a7e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27039ac658a9bc751ac0459a4241b0fdc8a9e9f272f739585308814a8075a7e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27039ac658a9bc751ac0459a4241b0fdc8a9e9f272f739585308814a8075a7e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d9e57f9e32d70c15ce040480ec3527f1b5c2e2a678333f5dcd35da0bbf4e955"
    sha256 cellar: :any_skip_relocation, ventura:       "3d9e57f9e32d70c15ce040480ec3527f1b5c2e2a678333f5dcd35da0bbf4e955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8404455fb3a8edbe63b48c20797ae85577a1e71fae1cc9a80831214ad2f29769"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end