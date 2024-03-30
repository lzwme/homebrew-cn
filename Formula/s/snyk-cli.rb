require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1286.2.tgz"
  sha256 "4595989775ee69ca6eaa71be8f8bdd4a7c82ea6fd5bcfab3fb54275159317a8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da342b95ac5d69cfa1069891bedf1d629fe0c6c1e398e7285b57ce1b8e99f6fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fb20c0f6286cfaa9a20db5665eaca4b636b337b251cbc536864d3b6f2da2472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "501325074e2446a12b222cc67797a7c24e8b8cf88553a5f74c51aac5fa86a963"
    sha256 cellar: :any_skip_relocation, sonoma:         "117d315837f4aed5ca241fd18e1bb6b4ea93e584f39538567affd5197dd27a19"
    sha256 cellar: :any_skip_relocation, ventura:        "174e0e35745fcfc09f1a0b4919cc7462c597dfa3a250568e12119aebd1ad4492"
    sha256 cellar: :any_skip_relocation, monterey:       "7be16dd738088f4fcb86b0a962e553317a1ec520e8bd3053eda207eedeffdb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "480535030abcb3138ca9bb53455d214e2f137108b870b406c24bb8c0f2cfbc2e"
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