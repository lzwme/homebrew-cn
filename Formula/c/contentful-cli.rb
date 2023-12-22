require "languagenode"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.1.33.tgz"
  sha256 "f9c6b0dabbf74cf666a82b2c97050c3e5bbaa33da88c3447784d1d6757fe92af"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec930b3406462eaecaf87ae73b216749751138da88acd1f4802c109b38d55938"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec930b3406462eaecaf87ae73b216749751138da88acd1f4802c109b38d55938"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec930b3406462eaecaf87ae73b216749751138da88acd1f4802c109b38d55938"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ee8536263c30657c6e7915455d29dd2bea78d9486be4eaab09656696b8c6832"
    sha256 cellar: :any_skip_relocation, ventura:        "9ee8536263c30657c6e7915455d29dd2bea78d9486be4eaab09656696b8c6832"
    sha256 cellar: :any_skip_relocation, monterey:       "9ee8536263c30657c6e7915455d29dd2bea78d9486be4eaab09656696b8c6832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec930b3406462eaecaf87ae73b216749751138da88acd1f4802c109b38d55938"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end