class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.269.tgz"
  sha256 "78686b21c82e6861204f6e9d449c65686fdf8fa13322d11fa22f12267cc20779"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8211060cd7e132cb97a66f3097000458a3010e428a08d481a6b7a701f68e6109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8211060cd7e132cb97a66f3097000458a3010e428a08d481a6b7a701f68e6109"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8211060cd7e132cb97a66f3097000458a3010e428a08d481a6b7a701f68e6109"
    sha256 cellar: :any_skip_relocation, sonoma:        "118bffdf1f9a0dc23a2be3e5e9b479141d952ec913259cbf8f23fca74d1d0739"
    sha256 cellar: :any_skip_relocation, ventura:       "118bffdf1f9a0dc23a2be3e5e9b479141d952ec913259cbf8f23fca74d1d0739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8211060cd7e132cb97a66f3097000458a3010e428a08d481a6b7a701f68e6109"
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