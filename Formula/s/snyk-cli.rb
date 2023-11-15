require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1245.0.tgz"
  sha256 "a1521974dec52c87fa02c1d10ad9c60d7f3a30526787185dd6c079db645aa37b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c9b8f1d6746ade0956b9324367ca4b55e9dada795ca5c8b2ef06eaea8c44f0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0ed75c21a5b215183992ce4119fb25b4d02c8e2347325b962a16011601b216b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aff655cd4188c50a4aecc20578949fb7ede87e6962f92a77a36338c74fdd3a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c952d86fc8f0d3c2ad9da59c552e5b2f0e9dc561a4f5a5689853abcbc6920fdc"
    sha256 cellar: :any_skip_relocation, ventura:        "34b9de41b8dbfe31baceb748d99153127b816392c8ef86296beb1e53b752ff68"
    sha256 cellar: :any_skip_relocation, monterey:       "6ff090140ba0b1871c3ac4d065eb32243ddcb531ef71ae90c218ad35e75111c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f3341ee9dda98fce93545921b31d0522b3bc8c1552b999e306c2f965a99637d"
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