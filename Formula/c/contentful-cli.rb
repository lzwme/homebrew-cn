class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.15.tgz"
  sha256 "59e051cf041d7959550923be2eb9df6153423b02e6e7e1b8f3f51be0d05e5721"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7ab474f7814c5f0f57a019d95189f6139bf3acfba01f173eafabbec0b61aa70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7ab474f7814c5f0f57a019d95189f6139bf3acfba01f173eafabbec0b61aa70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7ab474f7814c5f0f57a019d95189f6139bf3acfba01f173eafabbec0b61aa70"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b71cc32409d26ba310a24735b5bbd52cd281c2402ba89fab851f70dfff84927"
    sha256 cellar: :any_skip_relocation, ventura:       "7b71cc32409d26ba310a24735b5bbd52cd281c2402ba89fab851f70dfff84927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ab474f7814c5f0f57a019d95189f6139bf3acfba01f173eafabbec0b61aa70"
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