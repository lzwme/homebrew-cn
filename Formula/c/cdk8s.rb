require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.102.tgz"
  sha256 "c08d0c3b7f9cada152c21bb76e953f7415a96c807f46f9c4d0b84e97a642be4d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bd82bdc32435ef49ad39f45ab04796a9ae12aa83221a61ba593f97a77d35c51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bd82bdc32435ef49ad39f45ab04796a9ae12aa83221a61ba593f97a77d35c51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bd82bdc32435ef49ad39f45ab04796a9ae12aa83221a61ba593f97a77d35c51"
    sha256 cellar: :any_skip_relocation, sonoma:         "db56b83cc6671a2369998113986a944cbc1e946e27234646f2f8204b6f33aa27"
    sha256 cellar: :any_skip_relocation, ventura:        "db56b83cc6671a2369998113986a944cbc1e946e27234646f2f8204b6f33aa27"
    sha256 cellar: :any_skip_relocation, monterey:       "db56b83cc6671a2369998113986a944cbc1e946e27234646f2f8204b6f33aa27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bd82bdc32435ef49ad39f45ab04796a9ae12aa83221a61ba593f97a77d35c51"
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