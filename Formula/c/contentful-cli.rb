class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.4.4.tgz"
  sha256 "1ea4f9f48a683e1e19c6628176577c20383a6902a6c130ca0cc8a44cf97537c8"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f2006308f2b4c8a8ad5d3aa2a22cddc8476746495dffc5f4c4d0c386ed5e5ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f2006308f2b4c8a8ad5d3aa2a22cddc8476746495dffc5f4c4d0c386ed5e5ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f2006308f2b4c8a8ad5d3aa2a22cddc8476746495dffc5f4c4d0c386ed5e5ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "584e3df4e80987ed5eb19772e67b37c800c158705857509781ca1980092c1c4d"
    sha256 cellar: :any_skip_relocation, ventura:       "584e3df4e80987ed5eb19772e67b37c800c158705857509781ca1980092c1c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2006308f2b4c8a8ad5d3aa2a22cddc8476746495dffc5f4c4d0c386ed5e5ac"
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