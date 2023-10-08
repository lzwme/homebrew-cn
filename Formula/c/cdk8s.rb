require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.129.0.tgz"
  sha256 "a4a990e396fa3bc1b7d9721a06a07d65eb3017b21eb1f599f576fd42f1551be6"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce11bd6c54e621279673236ceaee1e9972efe12b6339fc9306480a5dab131a29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce11bd6c54e621279673236ceaee1e9972efe12b6339fc9306480a5dab131a29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce11bd6c54e621279673236ceaee1e9972efe12b6339fc9306480a5dab131a29"
    sha256 cellar: :any_skip_relocation, sonoma:         "2331acb8e051a9b417cc0c9853bd8d027291fd85c152985b75cdf8a0ca083527"
    sha256 cellar: :any_skip_relocation, ventura:        "2331acb8e051a9b417cc0c9853bd8d027291fd85c152985b75cdf8a0ca083527"
    sha256 cellar: :any_skip_relocation, monterey:       "2331acb8e051a9b417cc0c9853bd8d027291fd85c152985b75cdf8a0ca083527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce11bd6c54e621279673236ceaee1e9972efe12b6339fc9306480a5dab131a29"
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