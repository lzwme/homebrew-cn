class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.0.tgz"
  sha256 "bc61ce1c4b104290bbe1424625da96320f5224d6c71d62f2152fde906504b240"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8df1afec0e916024b07a732a8829302343476dbad4aff509a86d2cc2eedd7c89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8df1afec0e916024b07a732a8829302343476dbad4aff509a86d2cc2eedd7c89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8df1afec0e916024b07a732a8829302343476dbad4aff509a86d2cc2eedd7c89"
    sha256 cellar: :any_skip_relocation, sonoma:        "08ad94d5fe897530ada84badbcb8ca473813e82472d7ca72d04d7bd10e16eac2"
    sha256 cellar: :any_skip_relocation, ventura:       "08ad94d5fe897530ada84badbcb8ca473813e82472d7ca72d04d7bd10e16eac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6f6b510e06ff82afb8fa98f8804749639f6d134753bfac166984cab0dd0122c"
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