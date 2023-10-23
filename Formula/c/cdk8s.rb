require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.151.0.tgz"
  sha256 "ce7d153daad6a51e115d32a3afc43296e09a403d6fce8e489dd078c0e9008a1f"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8986d73f3fd6b72d4d05909443b04349f0f8c05cab7bcaca32e7b72880312bea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8986d73f3fd6b72d4d05909443b04349f0f8c05cab7bcaca32e7b72880312bea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8986d73f3fd6b72d4d05909443b04349f0f8c05cab7bcaca32e7b72880312bea"
    sha256 cellar: :any_skip_relocation, sonoma:         "3090ccfebdd1c8a0a2abdd83188f6e700646d98d56af3d716846a9e3963b42b9"
    sha256 cellar: :any_skip_relocation, ventura:        "3090ccfebdd1c8a0a2abdd83188f6e700646d98d56af3d716846a9e3963b42b9"
    sha256 cellar: :any_skip_relocation, monterey:       "3090ccfebdd1c8a0a2abdd83188f6e700646d98d56af3d716846a9e3963b42b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8986d73f3fd6b72d4d05909443b04349f0f8c05cab7bcaca32e7b72880312bea"
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