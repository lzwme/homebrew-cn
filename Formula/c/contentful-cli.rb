class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.5.4.tgz"
  sha256 "5626345775f1a9d48304931f958b8419ad855de4ffeb2fc76dfa8ad2759b5772"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c025455fccc0d1ebd01a769582f9c71fe7393ed2030f6d3e76d4ef25a5bbdf3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c025455fccc0d1ebd01a769582f9c71fe7393ed2030f6d3e76d4ef25a5bbdf3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c025455fccc0d1ebd01a769582f9c71fe7393ed2030f6d3e76d4ef25a5bbdf3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "71739011b0aebb96eb436ef65d9334e9f0ce526764f1a5311d095d1bacc9f645"
    sha256 cellar: :any_skip_relocation, ventura:       "71739011b0aebb96eb436ef65d9334e9f0ce526764f1a5311d095d1bacc9f645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c025455fccc0d1ebd01a769582f9c71fe7393ed2030f6d3e76d4ef25a5bbdf3d"
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