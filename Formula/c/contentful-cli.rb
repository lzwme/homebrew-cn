class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.5.tgz"
  sha256 "4c9e5ac630610176c2fd4c8facc0e088b72b5f363d338e0c928064ad4270787e"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b259adeeada16168d892ad2e05a84f7390c701dd33eae04f177e9856f48a5943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b259adeeada16168d892ad2e05a84f7390c701dd33eae04f177e9856f48a5943"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b259adeeada16168d892ad2e05a84f7390c701dd33eae04f177e9856f48a5943"
    sha256 cellar: :any_skip_relocation, sonoma:        "40e786945e02efbef3ff1737a9affd5370e9707ae4ce4c4348a253b3aa817fc9"
    sha256 cellar: :any_skip_relocation, ventura:       "40e786945e02efbef3ff1737a9affd5370e9707ae4ce4c4348a253b3aa817fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b35cff8a4aeb841cafc8197492e8ce68e6144b5256b9e46b354f411832631a62"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end