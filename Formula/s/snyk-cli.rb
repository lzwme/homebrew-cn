class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1292.2.tgz"
  sha256 "6d12f6451c0ac5e2e1263da6b9a6e6de6366e052fadaca2f82fd070ce7b6b534"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "738ac8c80466b7d07ce4763ab29513707f2c011fba3607df92c5de622aeca1bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "738ac8c80466b7d07ce4763ab29513707f2c011fba3607df92c5de622aeca1bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "738ac8c80466b7d07ce4763ab29513707f2c011fba3607df92c5de622aeca1bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6d1ce2ac05c0be496a5b9af332b9f139c2dc1184f544264e728411a67676523"
    sha256 cellar: :any_skip_relocation, ventura:        "a6d1ce2ac05c0be496a5b9af332b9f139c2dc1184f544264e728411a67676523"
    sha256 cellar: :any_skip_relocation, monterey:       "a6d1ce2ac05c0be496a5b9af332b9f139c2dc1184f544264e728411a67676523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ece7d30d77bdc8f6f1f47341eb455645bfe8316710b059e8f36687fe1dde5b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end