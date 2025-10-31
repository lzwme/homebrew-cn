class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.9.tgz"
  sha256 "22cbf571fbb9a02cc5bc60bc52364c5bd2bfb02eb3a20e67e4ef87b420c9ee2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8af93d7abc42b4ac35a348616c2ffa062857502b162cd82c90c88d9e92e2544b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8af93d7abc42b4ac35a348616c2ffa062857502b162cd82c90c88d9e92e2544b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8af93d7abc42b4ac35a348616c2ffa062857502b162cd82c90c88d9e92e2544b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af93d7abc42b4ac35a348616c2ffa062857502b162cd82c90c88d9e92e2544b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8af93d7abc42b4ac35a348616c2ffa062857502b162cd82c90c88d9e92e2544b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b10600d8e7494f938bf0a295bf98ec9d3602cd78b635ebaa2a60c94e1fe187ce"
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