class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.8.tgz"
  sha256 "64c3beb18bbf1a1192e35289fdb46ad863888c0cf8cf7bfc0d55bb9a21b2af64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "313075bfc67170fdc014cacd195d0883f9a3809372e16af12667abda13bfd314"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end