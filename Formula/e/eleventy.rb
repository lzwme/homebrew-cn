class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https:www.11ty.dev"
  url "https:registry.npmjs.org@11tyeleventy-eleventy-3.1.1.tgz"
  sha256 "eff794b0b2d435532af76a75a2049914923e9ab183c517b4061a1cb9d26bf195"
  license "MIT"
  head "https:github.com11tyeleventy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ad4a19fb02401364c5066a30b5dd4fe0e3c01c0947fd8ddb39477d49f0593b9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"README.md").write "# Hello from Homebrew\nThis is a test."
    system bin"eleventy"
    assert_equal "<h1>Hello from Homebrew<h1>\n<p>This is a test.<p>\n",
                 (testpath"_siteREADMEindex.html").read
  end
end