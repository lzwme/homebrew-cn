class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.10.tgz"
  sha256 "9a3c46a22b6e3e6c862cc4f3d265243204937c81e143424e9e10dd029a42f7ff"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75f8ccca50f7a0903584b2aa3b5547cb865a6e017523c324cd1daa0f304ad565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75f8ccca50f7a0903584b2aa3b5547cb865a6e017523c324cd1daa0f304ad565"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75f8ccca50f7a0903584b2aa3b5547cb865a6e017523c324cd1daa0f304ad565"
    sha256 cellar: :any_skip_relocation, sonoma:        "23c0cf02d673c36d91d650cb461bb9c9104825b9588ff32883e2c0998ad569ad"
    sha256 cellar: :any_skip_relocation, ventura:       "23c0cf02d673c36d91d650cb461bb9c9104825b9588ff32883e2c0998ad569ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "854227f2d6917677c437de0f6f89290c6299393d96b5bde2d28c75f920b6e6f2"
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