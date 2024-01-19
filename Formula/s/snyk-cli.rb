require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1270.0.tgz"
  sha256 "49bca7628a4bfc0c6f2355ea15d565d4763b938f0402f12a06b6c14ce39a4da1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38838c3dbbe5b69f7c9aceaf75f418eb7a35ac74d79aecda391067859497dcad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb035c18295e2141f93f1d8b5d9e6d6d3416f12f8baae219aed1ed567e96a4e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e68ad1c054ebb75e4d6735643e094ff9c3e872da87785c018982d9746612115"
    sha256 cellar: :any_skip_relocation, sonoma:         "e068548f2054d692d626d014f16dbc5c1ade5a485390d2e6aeb5fd6053c8505d"
    sha256 cellar: :any_skip_relocation, ventura:        "c9141b01151c5426d8eea7626dfc8fc5367f4602c8c05250abfe8b8681a9cb3d"
    sha256 cellar: :any_skip_relocation, monterey:       "4ec8ec534f782bc8d973e74bf58fa2feecf2d52488e264dae488dd993a75f381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3337b7a5cb4a05884f311ade21d6e2702d5ca289c6180033fc7685419466160"
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