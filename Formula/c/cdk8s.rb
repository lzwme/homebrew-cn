require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.90.tgz"
  sha256 "fa5c9728ab9d94bc969883123bdf37a8a40ccc828b7378127310fd355a94d807"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "baeba58c8f4244ba5849b1ba902073ba817c12067064aa7dc77cdd354009d67e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baeba58c8f4244ba5849b1ba902073ba817c12067064aa7dc77cdd354009d67e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baeba58c8f4244ba5849b1ba902073ba817c12067064aa7dc77cdd354009d67e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8078c20ef46289f45a2fd8f70cbd63ec34142ee03fe8a620c5f49638cbc5d255"
    sha256 cellar: :any_skip_relocation, ventura:        "8078c20ef46289f45a2fd8f70cbd63ec34142ee03fe8a620c5f49638cbc5d255"
    sha256 cellar: :any_skip_relocation, monterey:       "8078c20ef46289f45a2fd8f70cbd63ec34142ee03fe8a620c5f49638cbc5d255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baeba58c8f4244ba5849b1ba902073ba817c12067064aa7dc77cdd354009d67e"
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