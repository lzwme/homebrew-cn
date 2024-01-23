require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1272.0.tgz"
  sha256 "e7939cf842f5d4049ff1416570ecf55c04ae420d2c2e259c501499c5c6dd739e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9386cacb3d757e5536a2ab2bd400442c01a744e0cda1c669dd57f169b6b5c2cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "917e128d2ef6bdc7e3af1a065c6aa0e5e4c2971a16275a556ca579af0781307c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beb34679b1b8562ce36c050f5775fc5be32bd5916e9431204ead32103f1e64be"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d393af8dee4102b677cec644dc66e2273c9089dab88a576af9b46395b6b9288"
    sha256 cellar: :any_skip_relocation, ventura:        "b491ae70488ea00c9c941bdd0160c5dfed31a2c09be586b4d54149b9bfe4d306"
    sha256 cellar: :any_skip_relocation, monterey:       "24540804628e5bb738f235d5c72ded1aaf3270de42a64e9651a9536c75b1c717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fc6395e20a7961cd3e8b2c930b003074a55af65117e493ac841c7e663b37f27"
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