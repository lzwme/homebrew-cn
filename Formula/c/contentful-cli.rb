class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.6.tgz"
  sha256 "8762ee522cbf9a6aa1812b8ceba0e55cea643b81f5f2bcc83d25f66acdbe6b56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47b1f843288c096a70c30624d662ab793805ce12b7cf81a134ddea45d2fbaf6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b1f843288c096a70c30624d662ab793805ce12b7cf81a134ddea45d2fbaf6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47b1f843288c096a70c30624d662ab793805ce12b7cf81a134ddea45d2fbaf6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "47b1f843288c096a70c30624d662ab793805ce12b7cf81a134ddea45d2fbaf6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47b1f843288c096a70c30624d662ab793805ce12b7cf81a134ddea45d2fbaf6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea6e8904835e372d486080b70693e12fcf6a6f09a4b241df52e8fbfd0b1c42bd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end