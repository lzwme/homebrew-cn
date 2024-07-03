require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.162.tgz"
  sha256 "3cf006e807e1e4ae666fcdd2955eace252ea50a25527d0246702ac1c6328893e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42127cd328030e1d0fc604a141878d29f9c0a02ab8328092babb27ada8d6e982"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42127cd328030e1d0fc604a141878d29f9c0a02ab8328092babb27ada8d6e982"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42127cd328030e1d0fc604a141878d29f9c0a02ab8328092babb27ada8d6e982"
    sha256 cellar: :any_skip_relocation, sonoma:         "a82e7c6e004d3d7661f5b6311a706d6dcb70cec2a34eedf5489d56755c74af28"
    sha256 cellar: :any_skip_relocation, ventura:        "a82e7c6e004d3d7661f5b6311a706d6dcb70cec2a34eedf5489d56755c74af28"
    sha256 cellar: :any_skip_relocation, monterey:       "a82e7c6e004d3d7661f5b6311a706d6dcb70cec2a34eedf5489d56755c74af28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee8965c8b4cec5526440184425529d8e4676ff949920c0727a44be103e599494"
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