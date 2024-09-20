class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.11.tgz"
  sha256 "12707b6e4c8f6e87ed9a72894b4b6d1a737696f30af79ce9880d66e4d059e387"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35b0e65d9e7b3a0665948dff67949409300e3f9829930216eb234ce5024ca726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35b0e65d9e7b3a0665948dff67949409300e3f9829930216eb234ce5024ca726"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35b0e65d9e7b3a0665948dff67949409300e3f9829930216eb234ce5024ca726"
    sha256 cellar: :any_skip_relocation, sonoma:        "97b49347ef9627f80ba01d23a2ce81c598001c3c4329ee41e0526d7d40db36bc"
    sha256 cellar: :any_skip_relocation, ventura:       "97b49347ef9627f80ba01d23a2ce81c598001c3c4329ee41e0526d7d40db36bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35b0e65d9e7b3a0665948dff67949409300e3f9829930216eb234ce5024ca726"
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