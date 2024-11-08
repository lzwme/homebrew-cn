class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.5.2.tgz"
  sha256 "e5f592f073be0b978a00f44471983e08799aaf03e6862f8c1e42b20cf81aee26"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8642b67bbad5da70e5796a08e9d44aa5854ec27d73cd0640187e4167fed32e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8642b67bbad5da70e5796a08e9d44aa5854ec27d73cd0640187e4167fed32e03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8642b67bbad5da70e5796a08e9d44aa5854ec27d73cd0640187e4167fed32e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd3ef883966562bbfab20f446b4d26fdda9e3a1d8e18b4d354c1a1fbd227e253"
    sha256 cellar: :any_skip_relocation, ventura:       "cd3ef883966562bbfab20f446b4d26fdda9e3a1d8e18b4d354c1a1fbd227e253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8642b67bbad5da70e5796a08e9d44aa5854ec27d73cd0640187e4167fed32e03"
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