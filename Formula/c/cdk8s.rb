class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.316.tgz"
  sha256 "b42a9158fcfe9e75e45522d4775105f8a9c78f805251255eee1bfd9af737205d"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0667277a8975e6336ff0beb7fcce46ab442b946a78aefc32b76a2c5b5f15801c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0667277a8975e6336ff0beb7fcce46ab442b946a78aefc32b76a2c5b5f15801c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0667277a8975e6336ff0beb7fcce46ab442b946a78aefc32b76a2c5b5f15801c"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b8b5d56baa51959f5e2d4d936109d3a06c483678b75cdbdfdf5ede53bb3b7a"
    sha256 cellar: :any_skip_relocation, ventura:       "61b8b5d56baa51959f5e2d4d936109d3a06c483678b75cdbdfdf5ede53bb3b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0667277a8975e6336ff0beb7fcce46ab442b946a78aefc32b76a2c5b5f15801c"
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