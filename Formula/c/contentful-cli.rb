class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.8.4.tgz"
  sha256 "c48f4ed553fe6a625cc7d88efe59f858742ffe81d97f397b3a3299311d9aed6c"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e311472ce4efb92b5336c9cf138596567ad2f75572401e2e894b09cbc3c7edd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e311472ce4efb92b5336c9cf138596567ad2f75572401e2e894b09cbc3c7edd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e311472ce4efb92b5336c9cf138596567ad2f75572401e2e894b09cbc3c7edd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7c8ebe3966d9bd215066e47265266981bdcd1570ed734b01763a67b86e0e5ef"
    sha256 cellar: :any_skip_relocation, ventura:       "b7c8ebe3966d9bd215066e47265266981bdcd1570ed734b01763a67b86e0e5ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e311472ce4efb92b5336c9cf138596567ad2f75572401e2e894b09cbc3c7edd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ba79f9fed66e441ec55ecc0f567819e2a7efabb78fab9710fb52ccf1d69fde"
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