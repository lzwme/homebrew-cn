require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.118.0.tgz"
  sha256 "b556884d237ee84644adce1bcbe91406dac88eff91763ea9e0c6ac2bc82b448b"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c240416d5ad43681ba22aa4e4c5fee794501a3bc0a962233511bfbf560d00e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c240416d5ad43681ba22aa4e4c5fee794501a3bc0a962233511bfbf560d00e45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c240416d5ad43681ba22aa4e4c5fee794501a3bc0a962233511bfbf560d00e45"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd0140cdf30ceb657878f50f2f8d239d17b342a4594b70ef08b54e3197735ba3"
    sha256 cellar: :any_skip_relocation, ventura:        "fd0140cdf30ceb657878f50f2f8d239d17b342a4594b70ef08b54e3197735ba3"
    sha256 cellar: :any_skip_relocation, monterey:       "fd0140cdf30ceb657878f50f2f8d239d17b342a4594b70ef08b54e3197735ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c240416d5ad43681ba22aa4e4c5fee794501a3bc0a962233511bfbf560d00e45"
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