require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1246.0.tgz"
  sha256 "8c62c2776a80e692d827a2ac99ee724c698382323e5a68a72a0c67122362c9f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90fb6cfd28e31a259b6faa2fec52b2c18ced4e2da28ebd3536d188c449dd8ece"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b9d8602ea5533800ac79b189e51917658c80716e32b0bcbc6a4032488cf8b36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9dd74b0ba5996420e80e0a8ce02769bc85331e43ee77d7bb025b6f67dcab1b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "89226228fc37fffb152a1db7fd2b79ff31f588d77a9eb7556958dc5c4abb41c4"
    sha256 cellar: :any_skip_relocation, ventura:        "d862699306615c3099a6dfada6035c1150779c668de7805ecbd2e4dcc6c09e92"
    sha256 cellar: :any_skip_relocation, monterey:       "7b1c1ab6b90d1dae2cf94d665d1a34a9ddb1cdcec3df0125df0cb643a77e4780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55f1b841ea46a46d95cfbecd3fff6c1b4cd5650ed2a29884f777178d2c7f3582"
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