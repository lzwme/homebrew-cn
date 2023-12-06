require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.19.tgz"
  sha256 "496ada5a25b2a523ca83ecc4ade52eb9f7b48c143e5696fa14487ab90dd087a5"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be9b16b3631adc16757e9fc10c44a44d752f9152234384528f32ba64552e2fba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be9b16b3631adc16757e9fc10c44a44d752f9152234384528f32ba64552e2fba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be9b16b3631adc16757e9fc10c44a44d752f9152234384528f32ba64552e2fba"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a56cc3ebc3bdb3c514c9b35c33d856d72f83406664834cb1c8ec98c69162396"
    sha256 cellar: :any_skip_relocation, ventura:        "0a56cc3ebc3bdb3c514c9b35c33d856d72f83406664834cb1c8ec98c69162396"
    sha256 cellar: :any_skip_relocation, monterey:       "0a56cc3ebc3bdb3c514c9b35c33d856d72f83406664834cb1c8ec98c69162396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9b16b3631adc16757e9fc10c44a44d752f9152234384528f32ba64552e2fba"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end