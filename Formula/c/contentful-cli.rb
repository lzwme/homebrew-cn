class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.9.tgz"
  sha256 "7a4d6dcab4346aeb0a2b4d57fba6444da82d158102bef567dfc168a8e17f6b17"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "403e06a2574f3ff391f8f54176855250a8c38954418ad5d129e5a0c4880b0e4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "403e06a2574f3ff391f8f54176855250a8c38954418ad5d129e5a0c4880b0e4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "403e06a2574f3ff391f8f54176855250a8c38954418ad5d129e5a0c4880b0e4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba7a32735992f53155b5e49ce6a076bc4c30f23a86f6131d6d652bfd1bebd1d3"
    sha256 cellar: :any_skip_relocation, ventura:        "ba7a32735992f53155b5e49ce6a076bc4c30f23a86f6131d6d652bfd1bebd1d3"
    sha256 cellar: :any_skip_relocation, monterey:       "ba7a32735992f53155b5e49ce6a076bc4c30f23a86f6131d6d652bfd1bebd1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403e06a2574f3ff391f8f54176855250a8c38954418ad5d129e5a0c4880b0e4f"
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