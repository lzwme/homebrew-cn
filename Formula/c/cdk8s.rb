class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.22.tgz"
  sha256 "fa64fe33b65da291b738a4e0b939cb78f284db9ec6d3bc52063b3dc3018350e9"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52caeae12ffc846ab81ae28302071f325dbdfb7f687130d32d15a91735bec306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52caeae12ffc846ab81ae28302071f325dbdfb7f687130d32d15a91735bec306"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52caeae12ffc846ab81ae28302071f325dbdfb7f687130d32d15a91735bec306"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c284f50b5a02285aae5c8ba795baceafc3fa9a4f8a29b9981a8462a87358607"
    sha256 cellar: :any_skip_relocation, ventura:       "9c284f50b5a02285aae5c8ba795baceafc3fa9a4f8a29b9981a8462a87358607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52caeae12ffc846ab81ae28302071f325dbdfb7f687130d32d15a91735bec306"
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