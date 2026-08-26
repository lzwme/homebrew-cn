class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.9.tgz"
  sha256 "1cbaa08ff448e851b42de1602d63b6fad7c6a3868ca057689371cdcf50b1c059"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1594026779e0eb076d5e9e3f1363aeda6e1d76e5aa0b0a684f9f8f941124f23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1594026779e0eb076d5e9e3f1363aeda6e1d76e5aa0b0a684f9f8f941124f23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1594026779e0eb076d5e9e3f1363aeda6e1d76e5aa0b0a684f9f8f941124f23"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1594026779e0eb076d5e9e3f1363aeda6e1d76e5aa0b0a684f9f8f941124f23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1594026779e0eb076d5e9e3f1363aeda6e1d76e5aa0b0a684f9f8f941124f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8753cca174c8a238e780a07232210c1525b3c019cff001dadb9dca14c3abcf47"
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