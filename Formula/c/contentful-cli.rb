class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.5.10.tgz"
  sha256 "3c92143b7f60ef03eb95e702794d712749c00e88e35b98fa1f92d2c10a714e30"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "731d19562ba9f13e33ec866696bef28e0a1227c86440e401941fc09bbddc093b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "731d19562ba9f13e33ec866696bef28e0a1227c86440e401941fc09bbddc093b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "731d19562ba9f13e33ec866696bef28e0a1227c86440e401941fc09bbddc093b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9332ca1a4d8ce53e6e4ef37870d178a565d0d181d8a9895865cdfe7dfc508168"
    sha256 cellar: :any_skip_relocation, ventura:       "9332ca1a4d8ce53e6e4ef37870d178a565d0d181d8a9895865cdfe7dfc508168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1533c534f3a300ddeb344da7b1bc4c37a9fcd969795698d201b51338516f3145"
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