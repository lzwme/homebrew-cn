class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1295.1.tgz"
  sha256 "93c59814e837a56bde96c2f66f2765891180a2947606fbd783ff32fd5aa46366"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a04781f6741f787a9673645191588946500a1a25c1c317106f538104fe6ceb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52a04781f6741f787a9673645191588946500a1a25c1c317106f538104fe6ceb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52a04781f6741f787a9673645191588946500a1a25c1c317106f538104fe6ceb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b05af77bf47930c61acd4b2ed2c4c41483b0c47b4c902f50da1218bbfa64e666"
    sha256 cellar: :any_skip_relocation, ventura:       "b05af77bf47930c61acd4b2ed2c4c41483b0c47b4c902f50da1218bbfa64e666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e64fe60a7a301230d0ed88d22dabc77af8f5aaf0e6570bad3d2858fe0b7b78f"
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