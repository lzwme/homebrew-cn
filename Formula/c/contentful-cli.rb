class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.4.1.tgz"
  sha256 "5e2ebd7ea761e95ded3ddb47dba93b0a1cf9f89588b8b01045565476c3bec95e"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d389b1d906a6c1ab9e39ee047b3f40c222d645b560be4cf7c51c0095ede2bc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d389b1d906a6c1ab9e39ee047b3f40c222d645b560be4cf7c51c0095ede2bc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d389b1d906a6c1ab9e39ee047b3f40c222d645b560be4cf7c51c0095ede2bc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a08575eec2d5f0e1e6e781d827ed39113f258ee6b14781dd39962725a4582b3"
    sha256 cellar: :any_skip_relocation, ventura:       "4a08575eec2d5f0e1e6e781d827ed39113f258ee6b14781dd39962725a4582b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d389b1d906a6c1ab9e39ee047b3f40c222d645b560be4cf7c51c0095ede2bc1"
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