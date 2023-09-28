require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.107.0.tgz"
  sha256 "cc003df0a506b1407f6922d6bcf1ec1c08fff68e843f571f8346f3e95c636da7"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "617b1afb371da5cf7eea4d98e140f9b885ea10807e92718be848471a8544c7ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "617b1afb371da5cf7eea4d98e140f9b885ea10807e92718be848471a8544c7ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "617b1afb371da5cf7eea4d98e140f9b885ea10807e92718be848471a8544c7ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "afe04ffc9c55a1145d24c74281b87e672ce1b27cc15e5bd4e989419d3770fd1d"
    sha256 cellar: :any_skip_relocation, ventura:        "afe04ffc9c55a1145d24c74281b87e672ce1b27cc15e5bd4e989419d3770fd1d"
    sha256 cellar: :any_skip_relocation, monterey:       "ecbf1814bc40c813e5291305507b074cabfa9fa808c27498d78f0d966a62c137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "617b1afb371da5cf7eea4d98e140f9b885ea10807e92718be848471a8544c7ac"
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