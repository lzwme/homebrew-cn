class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.306.tgz"
  sha256 "7758ce28b0abe676d578e971c7f052e4792ed983bf086ada58d0d957a9d841e5"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65ab77f24880540adc4f8231d7094fa6108070c7ce332f4e4ed6062a336ac4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c65ab77f24880540adc4f8231d7094fa6108070c7ce332f4e4ed6062a336ac4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c65ab77f24880540adc4f8231d7094fa6108070c7ce332f4e4ed6062a336ac4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e4d5c702c8090beae42bd04c14a3a845b794fde75430c0e87e84bf07be00ab"
    sha256 cellar: :any_skip_relocation, ventura:       "44e4d5c702c8090beae42bd04c14a3a845b794fde75430c0e87e84bf07be00ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c65ab77f24880540adc4f8231d7094fa6108070c7ce332f4e4ed6062a336ac4c"
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