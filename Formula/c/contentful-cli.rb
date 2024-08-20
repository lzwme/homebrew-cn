class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.5.tgz"
  sha256 "b230e0082391932f8d676c1a69d17fa0217eef9c1df6de63d67b60a6818759c5"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d11d05e5951fb46c749a0e183a63bf2f7eb993f45f933dbc7820345743329318"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d11d05e5951fb46c749a0e183a63bf2f7eb993f45f933dbc7820345743329318"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d11d05e5951fb46c749a0e183a63bf2f7eb993f45f933dbc7820345743329318"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fb140212d898a51988074ef443ffa20bd27cd9fc2fb809f54aae7fc587ea960"
    sha256 cellar: :any_skip_relocation, ventura:        "9fb140212d898a51988074ef443ffa20bd27cd9fc2fb809f54aae7fc587ea960"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb140212d898a51988074ef443ffa20bd27cd9fc2fb809f54aae7fc587ea960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d11d05e5951fb46c749a0e183a63bf2f7eb993f45f933dbc7820345743329318"
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