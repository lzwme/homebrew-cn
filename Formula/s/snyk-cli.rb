class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1295.4.tgz"
  sha256 "2bce4c9466ef4db00bd8a99b4e6cbcf4b623cd359c62e0b74ad9c6c011d5e672"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18273eab136dad4da9b2ba8f746eada087cdeffdebaa6d5670bc672de294d28b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18273eab136dad4da9b2ba8f746eada087cdeffdebaa6d5670bc672de294d28b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18273eab136dad4da9b2ba8f746eada087cdeffdebaa6d5670bc672de294d28b"
    sha256 cellar: :any_skip_relocation, sonoma:        "13fa06fc30883ca22c677b18f4312af844d6c36f0f3e5425a102452f9d53b708"
    sha256 cellar: :any_skip_relocation, ventura:       "13fa06fc30883ca22c677b18f4312af844d6c36f0f3e5425a102452f9d53b708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee644fd83a972582847755d50982aa88e62d6cb737cdc42d89989068241a0996"
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