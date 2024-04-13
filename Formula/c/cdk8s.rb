require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.97.tgz"
  sha256 "1cf8a5a10aae048421831c13b0073c90808f61d4462a4f36e34cbc2642d0021a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5df3fd7a1047142c11020b516bced713aae82ea2706cdde208c71d503426ac75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5df3fd7a1047142c11020b516bced713aae82ea2706cdde208c71d503426ac75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5df3fd7a1047142c11020b516bced713aae82ea2706cdde208c71d503426ac75"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d358e37981182dc724171e622a0dce160428600ad19315d448bf05078f986cc"
    sha256 cellar: :any_skip_relocation, ventura:        "7d358e37981182dc724171e622a0dce160428600ad19315d448bf05078f986cc"
    sha256 cellar: :any_skip_relocation, monterey:       "7d358e37981182dc724171e622a0dce160428600ad19315d448bf05078f986cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5df3fd7a1047142c11020b516bced713aae82ea2706cdde208c71d503426ac75"
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