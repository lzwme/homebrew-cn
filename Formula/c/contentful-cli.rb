class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.4.tgz"
  sha256 "7c7f90ddac27dd2a1f84088e9a651941d4ac1a2d43ec7e11c54d533bfeaabeae"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47cea159e3289bbcad4ac846c390d7c254257577d6a86ffd51e4e2b4a3ae50da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47cea159e3289bbcad4ac846c390d7c254257577d6a86ffd51e4e2b4a3ae50da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47cea159e3289bbcad4ac846c390d7c254257577d6a86ffd51e4e2b4a3ae50da"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe21d6deb694166fef1fa014cb905fce918f4ec1962ef2f5ba1284f523fc5302"
    sha256 cellar: :any_skip_relocation, ventura:       "fe21d6deb694166fef1fa014cb905fce918f4ec1962ef2f5ba1284f523fc5302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0531da00be7bfb8eef8a8f32e62217e59ab456044f402d58f33a34b687879f43"
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