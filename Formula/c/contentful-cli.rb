class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.4.2.tgz"
  sha256 "2df000c8ddc660f81086a0afc990d7ecaaf8a5460ac386b324923425c9eac2c1"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9254c1b58b4f75a2b1c0e3c3e3589986581f86becf2f95d7019c3eee118aa4b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9254c1b58b4f75a2b1c0e3c3e3589986581f86becf2f95d7019c3eee118aa4b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9254c1b58b4f75a2b1c0e3c3e3589986581f86becf2f95d7019c3eee118aa4b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b60c0033673047c54c2e522c46c01d8746ae8c398a87c33b2fde6a596e72b03"
    sha256 cellar: :any_skip_relocation, ventura:       "7b60c0033673047c54c2e522c46c01d8746ae8c398a87c33b2fde6a596e72b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9254c1b58b4f75a2b1c0e3c3e3589986581f86becf2f95d7019c3eee118aa4b5"
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