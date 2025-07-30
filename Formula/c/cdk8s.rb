class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.144.tgz"
  sha256 "0fae99ed728a0346a717ab52203f735c8ebbeaf7e41c8f973c4620f5cf26288a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf933b19bcd851a9c8ee2dc64793652e8c802877fb25dce56bc833b42013f863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf933b19bcd851a9c8ee2dc64793652e8c802877fb25dce56bc833b42013f863"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf933b19bcd851a9c8ee2dc64793652e8c802877fb25dce56bc833b42013f863"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd7e41c97e4f875e52f9f2aba42e8447191ae53a6c7903fc7a56a6217b071f26"
    sha256 cellar: :any_skip_relocation, ventura:       "bd7e41c97e4f875e52f9f2aba42e8447191ae53a6c7903fc7a56a6217b071f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf933b19bcd851a9c8ee2dc64793652e8c802877fb25dce56bc833b42013f863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf933b19bcd851a9c8ee2dc64793652e8c802877fb25dce56bc833b42013f863"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end