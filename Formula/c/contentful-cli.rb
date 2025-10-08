class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.3.tgz"
  sha256 "db48a534f9c50c00858d8cc95222c614f8b813741a2b39cb4ee30f7f22603863"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25f00b8475ea09a8f4e51c3bf1aef9b85cfe434d3146057c1a32f23241e6d10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25f00b8475ea09a8f4e51c3bf1aef9b85cfe434d3146057c1a32f23241e6d10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25f00b8475ea09a8f4e51c3bf1aef9b85cfe434d3146057c1a32f23241e6d10"
    sha256 cellar: :any_skip_relocation, sonoma:        "d25f00b8475ea09a8f4e51c3bf1aef9b85cfe434d3146057c1a32f23241e6d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d25f00b8475ea09a8f4e51c3bf1aef9b85cfe434d3146057c1a32f23241e6d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d17df144bba180460344e305bed5bb93acf60649db7523946d5d6ea991b0ae6c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end