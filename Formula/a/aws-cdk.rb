require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.142.0.tgz"
  sha256 "a1b633bddaf518b701ceb6e5602f9952bec9dc59c3772f36e49ac4afddadab07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f40c55b79f5107ba3b9123d5c5999262df092886f87cf93c21f309b6e5085354"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8dff4cad08cb4120025f678fcc9619eaf45821bd485be94cc57efa60bbd923f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df4506dfab5de374c8398dd13b9eab5dfdb60153eadb186749ff44d5fca322bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "91fb6ee327fb8f88ac78da6956a50b565831216713138e056fbc312fb2bca8f1"
    sha256 cellar: :any_skip_relocation, ventura:        "6d7911312c8a1340515423316f6b6043e3b100fd90506e8707108c9c08848908"
    sha256 cellar: :any_skip_relocation, monterey:       "62130dba42f033775803e9a7423ea2e836af0fa62f857ce37edf88432de1cbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67ace264f4745d1d21966069fd430fe72ec06274e0d10c6375db845b53b409b1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}cdk init app --language=javascript")
      list = shell_output("#{bin}cdk list")
      cdkversion = shell_output("#{bin}cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end