class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.44.tgz"
  sha256 "c7c33acb22d6dab3bdcf410f8861aa1fbbad3ede0ac34712f315bf332bbfc5e1"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34f0167b2cc5ce4d84bd40f3394de33e23d29d3f6f86f09eb8b9a7beaac985f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34f0167b2cc5ce4d84bd40f3394de33e23d29d3f6f86f09eb8b9a7beaac985f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34f0167b2cc5ce4d84bd40f3394de33e23d29d3f6f86f09eb8b9a7beaac985f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2ded53119c3c432a4fa073e15ceadda81130d3a2911d05aace3e688d873c48b"
    sha256 cellar: :any_skip_relocation, ventura:       "d2ded53119c3c432a4fa073e15ceadda81130d3a2911d05aace3e688d873c48b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34f0167b2cc5ce4d84bd40f3394de33e23d29d3f6f86f09eb8b9a7beaac985f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f0167b2cc5ce4d84bd40f3394de33e23d29d3f6f86f09eb8b9a7beaac985f9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end