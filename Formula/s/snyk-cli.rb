require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1264.0.tgz"
  sha256 "2eebce1baf9186582ca11b6a5a0351b4c02752bf562fb5a8fbc504c6089ed159"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8d2ce696438042d5b31a5c1f79b6964ce1a1843f4a89e31f2b092f2726fad27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24a70aba355b1d592a314216e38f028075ee934944e33aed1f69de767d76f852"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f74dfff980f89e0224b2318d5998d1e2e21f0fe33f5d732d85f1ee12db24934"
    sha256 cellar: :any_skip_relocation, sonoma:         "2541aa92f382467532eae24485daa96281f5ee94919b4c26b53b19a993cfd058"
    sha256 cellar: :any_skip_relocation, ventura:        "3509e12e6bbd85652de19334d8498745ebc1e668f585ee2636e2f54da145adcb"
    sha256 cellar: :any_skip_relocation, monterey:       "47bba05eadee1887918708f04b93b0774adef955747ff36d9f438c35ff301520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09555573b7e69026d2b2b8fa89dc9a26a04a86f19df02edbf64ac8072325e265"
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