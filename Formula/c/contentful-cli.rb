class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.0.tgz"
  sha256 "1f9141816c427f7386cda8c2a196576acaa9595d83189d582531e6df8b0c70eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ca41d5bbf4e05b2a337ac8ed7398566e06beac51cd394c0daf61597c9ea1b10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ca41d5bbf4e05b2a337ac8ed7398566e06beac51cd394c0daf61597c9ea1b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ca41d5bbf4e05b2a337ac8ed7398566e06beac51cd394c0daf61597c9ea1b10"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ca41d5bbf4e05b2a337ac8ed7398566e06beac51cd394c0daf61597c9ea1b10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca41d5bbf4e05b2a337ac8ed7398566e06beac51cd394c0daf61597c9ea1b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56fa832133907bcdd05e7494d028ecdfc15091e6aa8332c991bc7ec2b8cf2414"
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