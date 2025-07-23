class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.8.10.tgz"
  sha256 "e11f638052cde719c5145200452126541b796eab385956e50af1f8d3be0b8d8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ebe27e073920248385b25790f9c143d10b851e38bb10be02650e9926006910c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ebe27e073920248385b25790f9c143d10b851e38bb10be02650e9926006910c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ebe27e073920248385b25790f9c143d10b851e38bb10be02650e9926006910c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f53be62aa3125f3cef6d62133d67a0c74602ec63f2b4e8e68135d8eb0705fc0"
    sha256 cellar: :any_skip_relocation, ventura:       "1f53be62aa3125f3cef6d62133d67a0c74602ec63f2b4e8e68135d8eb0705fc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ebe27e073920248385b25790f9c143d10b851e38bb10be02650e9926006910c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb2ab508674e51cc25096ac59fa94e9669c1f7eb2eccc67c0e591c168afd8c8"
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