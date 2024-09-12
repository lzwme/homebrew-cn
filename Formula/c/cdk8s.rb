class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.214.tgz"
  sha256 "9889fba1c887d6eb9e23f65e1a3d0fa146d70181a0dfedd1df3c49878720263d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6da2a21226923a5a2a588487947f70eb1c50e7665cba9ff6dae1d129cb48f34b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6da2a21226923a5a2a588487947f70eb1c50e7665cba9ff6dae1d129cb48f34b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6da2a21226923a5a2a588487947f70eb1c50e7665cba9ff6dae1d129cb48f34b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6da2a21226923a5a2a588487947f70eb1c50e7665cba9ff6dae1d129cb48f34b"
    sha256 cellar: :any_skip_relocation, sonoma:         "262accbded058f35cba314b7101f7aed64ccd76b8cf891d21b2db61c4748dd4a"
    sha256 cellar: :any_skip_relocation, ventura:        "262accbded058f35cba314b7101f7aed64ccd76b8cf891d21b2db61c4748dd4a"
    sha256 cellar: :any_skip_relocation, monterey:       "262accbded058f35cba314b7101f7aed64ccd76b8cf891d21b2db61c4748dd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6da2a21226923a5a2a588487947f70eb1c50e7665cba9ff6dae1d129cb48f34b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end