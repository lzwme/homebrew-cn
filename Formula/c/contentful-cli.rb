class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.14.tgz"
  sha256 "d55d9606f73579ab6061a87ede40a2e3ccd179da8cb63e7701cc2a21de143446"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4047048a45c576d8df80345b097fe904eab5ab467a6e87ab3c8bb4bb4640497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4047048a45c576d8df80345b097fe904eab5ab467a6e87ab3c8bb4bb4640497"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4047048a45c576d8df80345b097fe904eab5ab467a6e87ab3c8bb4bb4640497"
    sha256 cellar: :any_skip_relocation, sonoma:        "de806e612b654469f6860138dbeb265341ba27b944d6e603a57022ca16ada4df"
    sha256 cellar: :any_skip_relocation, ventura:       "de806e612b654469f6860138dbeb265341ba27b944d6e603a57022ca16ada4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4047048a45c576d8df80345b097fe904eab5ab467a6e87ab3c8bb4bb4640497"
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