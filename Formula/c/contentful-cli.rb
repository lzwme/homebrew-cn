class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.8.tgz"
  sha256 "48d43abee29600b071edec49e3d94e38c7f8ae4999acf5a5c3228590e907e6ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47579f1533a1d2e0fc10bfeb95a15fad2afb1bfcfcfda8e7d3ff72015da47b3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47579f1533a1d2e0fc10bfeb95a15fad2afb1bfcfcfda8e7d3ff72015da47b3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47579f1533a1d2e0fc10bfeb95a15fad2afb1bfcfcfda8e7d3ff72015da47b3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "47579f1533a1d2e0fc10bfeb95a15fad2afb1bfcfcfda8e7d3ff72015da47b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47579f1533a1d2e0fc10bfeb95a15fad2afb1bfcfcfda8e7d3ff72015da47b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a7f745078dd472d8afcd7c6e043b85900bf8a27e6d836d1f15b85af16d4688b"
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