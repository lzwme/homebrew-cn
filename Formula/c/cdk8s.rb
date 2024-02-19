require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.52.tgz"
  sha256 "8ea6f9a4008351d5bcec0a75b6a88bb74116e781e7c70924e94009b23c8a5518"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d42ed6fd2bb162df14e11c1cab5a4799f6e3dc483e89db61a91bb12e9c93c42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d42ed6fd2bb162df14e11c1cab5a4799f6e3dc483e89db61a91bb12e9c93c42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d42ed6fd2bb162df14e11c1cab5a4799f6e3dc483e89db61a91bb12e9c93c42"
    sha256 cellar: :any_skip_relocation, sonoma:         "e21a71eaa8cf5a29ba4efbb5e86f1cc8bb40da44c03204eb0bb479aa17aa3c7a"
    sha256 cellar: :any_skip_relocation, ventura:        "e21a71eaa8cf5a29ba4efbb5e86f1cc8bb40da44c03204eb0bb479aa17aa3c7a"
    sha256 cellar: :any_skip_relocation, monterey:       "e21a71eaa8cf5a29ba4efbb5e86f1cc8bb40da44c03204eb0bb479aa17aa3c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d42ed6fd2bb162df14e11c1cab5a4799f6e3dc483e89db61a91bb12e9c93c42"
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