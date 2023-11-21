require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1250.0.tgz"
  sha256 "dc4cd52c8386de30bf15382831c26fc2142aeb1f467eec1960027deff5518eca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f043178f2af6be452e9bbdf421dd6c200a74ffea27372ef9bc769029c949cea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d8fc6f12ec752c1c4befed4e2cbf2e44fbdc6a1772b32558ce858e0a3efdd24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42ecd84da4fd2930e6547d86490188ca5991e4bbc806a9ede9b00bd8a3c3feea"
    sha256 cellar: :any_skip_relocation, sonoma:         "639bca4ce76a76de7d98dcf165706e127351cd58934c2b6092b12083a67bf430"
    sha256 cellar: :any_skip_relocation, ventura:        "ebfa15457eaef28000e244c117fb71d4c789cf4e4303d51d37e790818fa8f3d5"
    sha256 cellar: :any_skip_relocation, monterey:       "e45c9818c92ba8e9c8cb124b08bd681c5c41862b6ad64c455393b97f0973c444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d1285cae28b0859cbf3f814388b0d52ae8240acab8c1cd5880f1fe825f2327"
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