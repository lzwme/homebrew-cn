require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1260.0.tgz"
  sha256 "83e3085989f934caccfff2131739d73589a1b7073a2a012fa274db5fcdfa8ef9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aa5415f50e2c37a02bf7b81bc79f48a378cf29d771c5d60929fe8840eb2c89e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a836f78dbc61fe0a92ea671e668485411f7638cebdacae33eb6b83d968943fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5acdb914a657396b85979e741e572b797ae7f24ef07df8eb9b865b9fbf318f90"
    sha256 cellar: :any_skip_relocation, sonoma:         "45d59cb991f9f2c594bf66141692bc6d8af42f8e15113cc46f95961aeb82604d"
    sha256 cellar: :any_skip_relocation, ventura:        "cf04af8eb1b5d40dae9a45c3c7e395ce88f7278c137dbf52349ad5bcd981fc47"
    sha256 cellar: :any_skip_relocation, monterey:       "a2ca641d43728e4a21dce046960017f6eb6001ef7cc2fb721f57220398eedd1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "947f6b71b295d7a6644f360adc9c9e6dbf4047688a21546b88d5d0f6813b25c8"
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