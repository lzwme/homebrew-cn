require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1240.0.tgz"
  sha256 "36e831463e7fa69ded244d0c8dcabd89cdc723baab4f148566ab64cc7f1d9794"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5290f473202b80d5d3735e101b2d13c06c6a6fe71fbf7ec3a65fa53c1d46055d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2188cf587ee891b984acb6f0b620df2578fa2cb03ab11253609a729c655b9cff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d3e705dd05bde87501771b4b63a38d9e233a6f376bd3505fb1011b0bef7b9a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "85302ad5fe78ffd95f86a433c50b7eb5f10fcc517e6299240120aa6f8378f07d"
    sha256 cellar: :any_skip_relocation, ventura:        "5b60413cc81f459434d6ad9fbe3078f9d2c3b67dd3f2a1d279727ab361e75cdc"
    sha256 cellar: :any_skip_relocation, monterey:       "ce8ae172a799882a34fc598ed8d59063c5f58d26eb7a051bc142dee1eba7debe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dc187dae23a69e227246344f4da708919e2af010efde45d0be48db770bb258d"
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