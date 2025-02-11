class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.320.tgz"
  sha256 "57db9e44a51518ab49436a726edc2b9d92bdef79cd36cbb726f3077a30063a1c"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc905b57666eea60d7612e46fd63f8b02c45b06f17ec8daf4ed88c07c9603d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cc905b57666eea60d7612e46fd63f8b02c45b06f17ec8daf4ed88c07c9603d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cc905b57666eea60d7612e46fd63f8b02c45b06f17ec8daf4ed88c07c9603d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a533332bd5a571180f202766918e9b593c90947d39dc93bf08dc8e1e19d30d7"
    sha256 cellar: :any_skip_relocation, ventura:       "7a533332bd5a571180f202766918e9b593c90947d39dc93bf08dc8e1e19d30d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc905b57666eea60d7612e46fd63f8b02c45b06f17ec8daf4ed88c07c9603d3"
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