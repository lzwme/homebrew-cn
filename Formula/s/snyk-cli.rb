class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1293.0.tgz"
  sha256 "fed2655a580122946517f10b880d8db74d9795da815dc5e03a3819e6777840dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5a54478f31a72668fa3760df70b46c9bbda3cc6a43fa2a0e0563b4257c1706ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a54478f31a72668fa3760df70b46c9bbda3cc6a43fa2a0e0563b4257c1706ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a54478f31a72668fa3760df70b46c9bbda3cc6a43fa2a0e0563b4257c1706ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a54478f31a72668fa3760df70b46c9bbda3cc6a43fa2a0e0563b4257c1706ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0974395978ed5f201ca88353fee1cb24b4a5a89c029f0aee696adb2a232b8c5"
    sha256 cellar: :any_skip_relocation, ventura:        "f0974395978ed5f201ca88353fee1cb24b4a5a89c029f0aee696adb2a232b8c5"
    sha256 cellar: :any_skip_relocation, monterey:       "f0974395978ed5f201ca88353fee1cb24b4a5a89c029f0aee696adb2a232b8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf442ae30cc96a8de0fceae2d55ae8e9cfe0ef35238e8a5decf5bccc60eb2d5b"
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