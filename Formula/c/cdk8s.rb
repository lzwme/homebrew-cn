class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.296.tgz"
  sha256 "0c5ceb85b14d70b173bedf2855dd2e09fa89dc39bbf38391e2dbe93fd8e94c57"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeb1e84857c0efd7cf7f43cba5c674ffefa92e76d027924a4c6a4757f5d24712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeb1e84857c0efd7cf7f43cba5c674ffefa92e76d027924a4c6a4757f5d24712"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eeb1e84857c0efd7cf7f43cba5c674ffefa92e76d027924a4c6a4757f5d24712"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c164bfc5915222da86e126831c141dcb36498b56b90e7901f662626f26d14d0"
    sha256 cellar: :any_skip_relocation, ventura:       "5c164bfc5915222da86e126831c141dcb36498b56b90e7901f662626f26d14d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeb1e84857c0efd7cf7f43cba5c674ffefa92e76d027924a4c6a4757f5d24712"
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