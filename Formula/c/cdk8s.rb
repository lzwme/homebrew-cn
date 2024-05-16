require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.119.tgz"
  sha256 "5eaafd0d633cfb114e4d8665c91a7a1b4ff0c279066a43ec887096f09cd528ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1fc46686ad1f01e42dc2107433707b89f7d839a7f1b95ab332cae9aefe0846b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ce48811575ecc5cb9c1bc1a0d343d8cf29a09b9095264bce13adb1c152c3c20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d0aa277e3902539b52fa4f01ca03bd34a2493d6663ecb158a15601e382c96ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "c730886c6126df806cb78f082f13cd312572f9ab79e8291bc0c2bcfce8139d7f"
    sha256 cellar: :any_skip_relocation, ventura:        "8ac45b8aeecc989aa9d5cb45b9fd2be263e04a1583048cd1a580cf20e0ede476"
    sha256 cellar: :any_skip_relocation, monterey:       "13a901ec4734ac3f503449613e7eb4b02e570bbc4e5f740a64e63c160cfdd723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b2c70d5af4a80bab991bcaa4954bf654d30cac98e505625b61aae46e9efa7c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end