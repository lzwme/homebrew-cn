require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1288.0.tgz"
  sha256 "9fb1f7ec875e113648fbe9f8aa8890c393d148bb9783d80ece24bb58835cb572"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa866c3741a99d7f08f38b05c89764b361dd29b5987b3447337f138787373754"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71340954d4ae37a97b63d00ac0340a2535eb7e04376f5dc5084fd33a1fe6e07a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50fd98ddc547ea0edb91866001c33237101582ce255996346271f2125ebce4c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4037fcbdf3ea15c6698503a0ac903936cc57554a3f9009589b7fa8eafbae2091"
    sha256 cellar: :any_skip_relocation, ventura:        "cc3f2e682555ebd03da16fc249a268122a33ddffbf5b62e91179a8677a8daadb"
    sha256 cellar: :any_skip_relocation, monterey:       "07f5762106e2b60bfd86cb1ac002eb697c7fa23c5da803a816ecd8eea2238a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3197a6306fcbd6f0db7cedb40b1579607397f10e098e6d1739d52d12ef3d6c30"
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