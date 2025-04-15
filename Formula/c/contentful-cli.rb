class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.8.6.tgz"
  sha256 "830d87cba3174eda116e9d0be6d0e770355cd3162d40c81ebead91937f2f8a01"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2585bb2bba5fea1b3d0b8bb271ed58bfd73d388b6163f80de2df6e57d9c390d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2585bb2bba5fea1b3d0b8bb271ed58bfd73d388b6163f80de2df6e57d9c390d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2585bb2bba5fea1b3d0b8bb271ed58bfd73d388b6163f80de2df6e57d9c390d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbd4c53d3d625cea3fb5bf7c11aa44e50a4c1c61d9ad3f3ba25202bc79567e8c"
    sha256 cellar: :any_skip_relocation, ventura:       "cbd4c53d3d625cea3fb5bf7c11aa44e50a4c1c61d9ad3f3ba25202bc79567e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2585bb2bba5fea1b3d0b8bb271ed58bfd73d388b6163f80de2df6e57d9c390d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40df80f25b363ea2904fa7f8d60382ad7abdd8091c1ce278dfd0660ce236f423"
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