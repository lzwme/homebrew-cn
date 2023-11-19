require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.180.0.tgz"
  sha256 "19a6234d48e47b94328dadc523a224222a284725533389f7491e7aeab444ce4e"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7edcdf307f06bc2cf41770d9984a070e48a5aee2ef6c25ab955b492158f535dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7edcdf307f06bc2cf41770d9984a070e48a5aee2ef6c25ab955b492158f535dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7edcdf307f06bc2cf41770d9984a070e48a5aee2ef6c25ab955b492158f535dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "105574fa54e33dbfa4560a84ee1ceeb01a6f163a87008301ea1f152cb2f9d8b5"
    sha256 cellar: :any_skip_relocation, ventura:        "105574fa54e33dbfa4560a84ee1ceeb01a6f163a87008301ea1f152cb2f9d8b5"
    sha256 cellar: :any_skip_relocation, monterey:       "105574fa54e33dbfa4560a84ee1ceeb01a6f163a87008301ea1f152cb2f9d8b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7edcdf307f06bc2cf41770d9984a070e48a5aee2ef6c25ab955b492158f535dd"
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