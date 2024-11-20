class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.5.8.tgz"
  sha256 "51294a7e818e829515881da33f50cc4704d9d6ce7f8a548896554ee8e40a47a9"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a23397338a6e47c2eca8cb7aa4717be0c9fc1fdb6f76d21c4188dff4836b00f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a23397338a6e47c2eca8cb7aa4717be0c9fc1fdb6f76d21c4188dff4836b00f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a23397338a6e47c2eca8cb7aa4717be0c9fc1fdb6f76d21c4188dff4836b00f"
    sha256 cellar: :any_skip_relocation, sonoma:        "acf2acf27c62160a9e2a9e514a5efa9ea13f82420125d03b04252ddf74d334af"
    sha256 cellar: :any_skip_relocation, ventura:       "acf2acf27c62160a9e2a9e514a5efa9ea13f82420125d03b04252ddf74d334af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a23397338a6e47c2eca8cb7aa4717be0c9fc1fdb6f76d21c4188dff4836b00f"
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