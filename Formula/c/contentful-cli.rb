require "languagenode"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.1.34.tgz"
  sha256 "0c5ed03f8f4856cc068924ec6022fb130032ad3f5954c3705859ba918fe4941c"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f8bec0e29227ddf061219a391bb53cca97a81c8c546d552a8d9d0c122978d58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f8bec0e29227ddf061219a391bb53cca97a81c8c546d552a8d9d0c122978d58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f8bec0e29227ddf061219a391bb53cca97a81c8c546d552a8d9d0c122978d58"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb87c1ca7a2da97a5e398748e54b6b098191a57066339e22a8a6e9578dd52a80"
    sha256 cellar: :any_skip_relocation, ventura:        "13f46b470544045cd64234e92422c8df3a2347c774c666a062e509bb3209c556"
    sha256 cellar: :any_skip_relocation, monterey:       "13f46b470544045cd64234e92422c8df3a2347c774c666a062e509bb3209c556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e314287f7ef02e70532f529c45da0a4e9b3fc140ff4cd780ea6195808e4c144"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end