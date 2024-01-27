require "languagenode"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.124.0.tgz"
  sha256 "d18fe57a074c509327e49e8a01ed44b1cc2180794d507286c49aef771d144da2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b76d40d7837e11c8aa6c68e3ceef4cb6bf61cb23e9b015d7b47bbf8bc243675"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b76d40d7837e11c8aa6c68e3ceef4cb6bf61cb23e9b015d7b47bbf8bc243675"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b76d40d7837e11c8aa6c68e3ceef4cb6bf61cb23e9b015d7b47bbf8bc243675"
    sha256 cellar: :any_skip_relocation, sonoma:         "b51cd034784c11ee9c5a501ec5ab62df33c7bca4332bca2f302a9f9f7e930a58"
    sha256 cellar: :any_skip_relocation, ventura:        "b51cd034784c11ee9c5a501ec5ab62df33c7bca4332bca2f302a9f9f7e930a58"
    sha256 cellar: :any_skip_relocation, monterey:       "b51cd034784c11ee9c5a501ec5ab62df33c7bca4332bca2f302a9f9f7e930a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fc1851af34b8bd4516a9461dc81badcc62b2bac415d991658ac06d61b4c1ccd"
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