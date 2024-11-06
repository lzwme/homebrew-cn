class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.4.6.tgz"
  sha256 "b431e161fd033fc05bb904d21b0413bc2363a5a461b6cf4c59e86c82afe15520"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4cdbd9915977d539489f8d3b31e0e2e773469501aeda74e5cbd4fdba9b259b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4cdbd9915977d539489f8d3b31e0e2e773469501aeda74e5cbd4fdba9b259b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4cdbd9915977d539489f8d3b31e0e2e773469501aeda74e5cbd4fdba9b259b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdf72ff9f76d43cdad5ce226ec951f6d6ceaf540af43e60e19f212623e20ce13"
    sha256 cellar: :any_skip_relocation, ventura:       "bdf72ff9f76d43cdad5ce226ec951f6d6ceaf540af43e60e19f212623e20ce13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4cdbd9915977d539489f8d3b31e0e2e773469501aeda74e5cbd4fdba9b259b2"
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