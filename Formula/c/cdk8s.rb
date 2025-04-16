class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.43.tgz"
  sha256 "64b4d97d0b8261e52ea09958db11df151a990e0def47601427c7f9bc6a27eb27"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "648d827e1db76c0d289739581916e1747596b4ee9a7022ca7ef756283cee020a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "648d827e1db76c0d289739581916e1747596b4ee9a7022ca7ef756283cee020a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "648d827e1db76c0d289739581916e1747596b4ee9a7022ca7ef756283cee020a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e70204b0cff3dcda95f8eb2b334893e4bb59ec2423cc5641dc5c288c602f08a3"
    sha256 cellar: :any_skip_relocation, ventura:       "e70204b0cff3dcda95f8eb2b334893e4bb59ec2423cc5641dc5c288c602f08a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "648d827e1db76c0d289739581916e1747596b4ee9a7022ca7ef756283cee020a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "648d827e1db76c0d289739581916e1747596b4ee9a7022ca7ef756283cee020a"
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