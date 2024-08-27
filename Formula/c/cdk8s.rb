class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.200.tgz"
  sha256 "54043bb0f4730a9b76cbaacd530bb1dfb7d55375df602f5ea8f18621feccca50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ab3154c6b378c6a9bfb7575eaf9f90305b193e426fac5c1d4ef3307122617f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ab3154c6b378c6a9bfb7575eaf9f90305b193e426fac5c1d4ef3307122617f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ab3154c6b378c6a9bfb7575eaf9f90305b193e426fac5c1d4ef3307122617f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a77fb15707d0a480df5552fc48f4d9dac085169c37df595eec9a054f41f2d57"
    sha256 cellar: :any_skip_relocation, ventura:        "6a77fb15707d0a480df5552fc48f4d9dac085169c37df595eec9a054f41f2d57"
    sha256 cellar: :any_skip_relocation, monterey:       "6a77fb15707d0a480df5552fc48f4d9dac085169c37df595eec9a054f41f2d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ab3154c6b378c6a9bfb7575eaf9f90305b193e426fac5c1d4ef3307122617f4"
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