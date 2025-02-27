class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.1.tgz"
  sha256 "ab2f494c6e532a339e2d455c5ded8533a4a4a69dacf05fd7953fc2606d1771d5"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa0f8d72fc0c39f40c0dd343c29d05cfddc4799c8a01c6bf8353bcb90470d93e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa0f8d72fc0c39f40c0dd343c29d05cfddc4799c8a01c6bf8353bcb90470d93e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa0f8d72fc0c39f40c0dd343c29d05cfddc4799c8a01c6bf8353bcb90470d93e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f91893b136e1bd1546bf832b6d76eb64f070c6fcd4d1db08983ef1d6e1839ee"
    sha256 cellar: :any_skip_relocation, ventura:       "4f91893b136e1bd1546bf832b6d76eb64f070c6fcd4d1db08983ef1d6e1839ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa0f8d72fc0c39f40c0dd343c29d05cfddc4799c8a01c6bf8353bcb90470d93e"
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