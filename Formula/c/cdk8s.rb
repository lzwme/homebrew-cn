require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.88.tgz"
  sha256 "d038b21516d494afb657ce1f525ee5205ca59c10a90348297b04e1dffe3beaa1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d97ff2c363c83d3f35b504afc13d344a75da7048390fe506f924bd058e41fb12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d97ff2c363c83d3f35b504afc13d344a75da7048390fe506f924bd058e41fb12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d97ff2c363c83d3f35b504afc13d344a75da7048390fe506f924bd058e41fb12"
    sha256 cellar: :any_skip_relocation, sonoma:         "c714b71a3f68cf8ce0d66c8050e9741f43f8d8b0a896779be38ac67efc9a5119"
    sha256 cellar: :any_skip_relocation, ventura:        "c714b71a3f68cf8ce0d66c8050e9741f43f8d8b0a896779be38ac67efc9a5119"
    sha256 cellar: :any_skip_relocation, monterey:       "c714b71a3f68cf8ce0d66c8050e9741f43f8d8b0a896779be38ac67efc9a5119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d97ff2c363c83d3f35b504afc13d344a75da7048390fe506f924bd058e41fb12"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end