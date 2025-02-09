class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.318.tgz"
  sha256 "1fba1dbaed4966a96272b4f0ba11d60dca445d3d46ce31ad3e8a0211532e27fe"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4275483f40c172c4e85fef45e3061f3be90e7eecdbc94ccaac43653a2ad38ec2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4275483f40c172c4e85fef45e3061f3be90e7eecdbc94ccaac43653a2ad38ec2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4275483f40c172c4e85fef45e3061f3be90e7eecdbc94ccaac43653a2ad38ec2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9adf66bfe91cfdb16e70d1333802b85a75fb1776ac5fdcf59cda7db4622cbc29"
    sha256 cellar: :any_skip_relocation, ventura:       "9adf66bfe91cfdb16e70d1333802b85a75fb1776ac5fdcf59cda7db4622cbc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4275483f40c172c4e85fef45e3061f3be90e7eecdbc94ccaac43653a2ad38ec2"
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