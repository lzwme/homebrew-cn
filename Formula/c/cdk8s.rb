require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.176.0.tgz"
  sha256 "ad59e3893b612e4bd4037c3b09efdb41992b9b41ea6e34c18e60a219d4539d67"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f386198adbc1dca6c7bc0e40ac3a23bd22c2799915979c46eab614297c0dde2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f386198adbc1dca6c7bc0e40ac3a23bd22c2799915979c46eab614297c0dde2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f386198adbc1dca6c7bc0e40ac3a23bd22c2799915979c46eab614297c0dde2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2ed30e0a859d453604e0ec1b133d0fbbc0c067d0781f10a1f8392f05351c380"
    sha256 cellar: :any_skip_relocation, ventura:        "b2ed30e0a859d453604e0ec1b133d0fbbc0c067d0781f10a1f8392f05351c380"
    sha256 cellar: :any_skip_relocation, monterey:       "b2ed30e0a859d453604e0ec1b133d0fbbc0c067d0781f10a1f8392f05351c380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f386198adbc1dca6c7bc0e40ac3a23bd22c2799915979c46eab614297c0dde2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end