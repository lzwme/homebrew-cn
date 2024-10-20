class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.250.tgz"
  sha256 "0d62429c979ced70371f282600c2bac897482a1d50ccc146bcdc9fe04b5f590d"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b3a8d8d883540706d0acb6ae05691c957d3bcdc12b35789d30260b74b8b7c46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b3a8d8d883540706d0acb6ae05691c957d3bcdc12b35789d30260b74b8b7c46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b3a8d8d883540706d0acb6ae05691c957d3bcdc12b35789d30260b74b8b7c46"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f1457c7c1fa7fe736634536a202da52c6571afdbd164f6a65b4a74c432ebfdd"
    sha256 cellar: :any_skip_relocation, ventura:       "1f1457c7c1fa7fe736634536a202da52c6571afdbd164f6a65b4a74c432ebfdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b3a8d8d883540706d0acb6ae05691c957d3bcdc12b35789d30260b74b8b7c46"
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