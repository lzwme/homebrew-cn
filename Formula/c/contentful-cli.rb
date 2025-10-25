class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.6.tgz"
  sha256 "b7db1fc8dac81b0aa6b74e0ced066378ddcf34d4b031e2990cb3e42be71b4e5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cec2a102e8ad902ec093d8fe2f0715af5dcbb18682a6f38414002f77171d9f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cec2a102e8ad902ec093d8fe2f0715af5dcbb18682a6f38414002f77171d9f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cec2a102e8ad902ec093d8fe2f0715af5dcbb18682a6f38414002f77171d9f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cec2a102e8ad902ec093d8fe2f0715af5dcbb18682a6f38414002f77171d9f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cec2a102e8ad902ec093d8fe2f0715af5dcbb18682a6f38414002f77171d9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfd86952ab7ff5464716b252617579141860affea090c4db698ccb4d58f09483"
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