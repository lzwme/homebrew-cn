class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.13.tgz"
  sha256 "d3b3502e1c966df44f11a3d5ee8ba0ebdf47a21266576a126eb3aa8625693e85"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2e8ab016a9f9d1a8ebe594c39b4c3610d5e46c7e81685f547fbaa91a7bd049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f2e8ab016a9f9d1a8ebe594c39b4c3610d5e46c7e81685f547fbaa91a7bd049"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f2e8ab016a9f9d1a8ebe594c39b4c3610d5e46c7e81685f547fbaa91a7bd049"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bdcfac800acda63b89e0e4e71c621e6c9104e052cddbf457534b2fdf3b432ed"
    sha256 cellar: :any_skip_relocation, ventura:       "2bdcfac800acda63b89e0e4e71c621e6c9104e052cddbf457534b2fdf3b432ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f2e8ab016a9f9d1a8ebe594c39b4c3610d5e46c7e81685f547fbaa91a7bd049"
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