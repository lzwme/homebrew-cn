class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.31.tgz"
  sha256 "61c5a4b5bfd8331ba7ba18072a7613f16f62da7f7745e764d285e4193cff9c29"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f2d2ace5e6bb7550052a4cacac1707d35b9c7e27d991730f4586cc6d0fecbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f2d2ace5e6bb7550052a4cacac1707d35b9c7e27d991730f4586cc6d0fecbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0f2d2ace5e6bb7550052a4cacac1707d35b9c7e27d991730f4586cc6d0fecbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "29b053a64e76fedb5cd170ccccac90214b2752a34da2f6a6a84900fb7370b8b3"
    sha256 cellar: :any_skip_relocation, ventura:       "29b053a64e76fedb5cd170ccccac90214b2752a34da2f6a6a84900fb7370b8b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0f2d2ace5e6bb7550052a4cacac1707d35b9c7e27d991730f4586cc6d0fecbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0f2d2ace5e6bb7550052a4cacac1707d35b9c7e27d991730f4586cc6d0fecbb"
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