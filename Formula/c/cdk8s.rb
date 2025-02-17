class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.326.tgz"
  sha256 "af65f56ba70b7c1cc02ab1ae13dad99094923fab672252ddff31511fff802b8f"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53db83adb143ee72c895981cc623c3cdbb9ea2fdcdee5227ff741912a4577e1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53db83adb143ee72c895981cc623c3cdbb9ea2fdcdee5227ff741912a4577e1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53db83adb143ee72c895981cc623c3cdbb9ea2fdcdee5227ff741912a4577e1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4db552c8de857841883ade7704eb37dfa9b160cb3d59d66ec9040df2451a01e5"
    sha256 cellar: :any_skip_relocation, ventura:       "4db552c8de857841883ade7704eb37dfa9b160cb3d59d66ec9040df2451a01e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53db83adb143ee72c895981cc623c3cdbb9ea2fdcdee5227ff741912a4577e1a"
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