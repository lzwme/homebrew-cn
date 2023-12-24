require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.17.tgz"
  sha256 "30df5c2bda9619f00800c7d9d66667c8606513036c877ee01d74925a91e39ccb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6292e3276b11cc75c60fb35329e2e66bef14d3b510f7abadd6d00043d1d9c50e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6292e3276b11cc75c60fb35329e2e66bef14d3b510f7abadd6d00043d1d9c50e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6292e3276b11cc75c60fb35329e2e66bef14d3b510f7abadd6d00043d1d9c50e"
    sha256 cellar: :any_skip_relocation, sonoma:         "19122543830b0186dca81899eb2786a1b116bbfef59d2788967f41470707f9f8"
    sha256 cellar: :any_skip_relocation, ventura:        "19122543830b0186dca81899eb2786a1b116bbfef59d2788967f41470707f9f8"
    sha256 cellar: :any_skip_relocation, monterey:       "19122543830b0186dca81899eb2786a1b116bbfef59d2788967f41470707f9f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6292e3276b11cc75c60fb35329e2e66bef14d3b510f7abadd6d00043d1d9c50e"
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