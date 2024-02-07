require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1278.0.tgz"
  sha256 "4ca8f480409aec6fbf76858dada6102219dc1f06dedce59fb4497ee97fb3a3af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e796af2108ea781efa21e2f6112e4ab9841cfde6b44c2015e47b647efaf74e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9470ebdef4e2bfc64100070e8ba0ea3840bf6518821de9d6c7fbcbfbdf12bec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baa4db36e2f57e91f971610beb050076f1866f9aa9c01750a4d00206ce2ad1ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "41baf81713513072655cb70ac8ec5411fd65e081873cb5265af1783eb0e19fb2"
    sha256 cellar: :any_skip_relocation, ventura:        "caa2ce27f3d6456ca7a37b8524d9add4ed8fa18c0c6e8c4b14c370921f83dc25"
    sha256 cellar: :any_skip_relocation, monterey:       "1d0caf3d5279cce355702b0237a107e57f71ffbaaf0ad17de3ff460cb58c3279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75f48f0cc0f37417777972b03c18ee66b71cf9a2fb4125915f1c56822ffd19bf"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end