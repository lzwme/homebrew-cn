class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.15.tgz"
  sha256 "d51f8d2e63d34544cf8eea374e69742fa9703809579dcec7706343dd92899979"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d05b59ca8c2902c3e216b751280f3276718a66af8bbd000d36ef869b66ff8452"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d05b59ca8c2902c3e216b751280f3276718a66af8bbd000d36ef869b66ff8452"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d05b59ca8c2902c3e216b751280f3276718a66af8bbd000d36ef869b66ff8452"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f422fa9f5d7fc801dd7569af44c41ee5c086e0aef33610630444b59df1d42c3"
    sha256 cellar: :any_skip_relocation, ventura:       "5f422fa9f5d7fc801dd7569af44c41ee5c086e0aef33610630444b59df1d42c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d05b59ca8c2902c3e216b751280f3276718a66af8bbd000d36ef869b66ff8452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1961e49c3d7ef4de2cdba57ba12d31a4d1e9889aacf8d7d283f8919aee2c2c92"
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