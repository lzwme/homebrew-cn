class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.5.7.tgz"
  sha256 "629fcc13d8dda8956e8eeb15efc61a0697e39afe7f1e7578f4fd47c9e174406b"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8245c0de72d24f00650ae3362bddbe433f4f2e06f71092634532d3fc8e85fe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8245c0de72d24f00650ae3362bddbe433f4f2e06f71092634532d3fc8e85fe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8245c0de72d24f00650ae3362bddbe433f4f2e06f71092634532d3fc8e85fe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fadf1ff0ed849a40e2ccc48874cd064ee7afb10764c9c9ae46eca20e71699e6"
    sha256 cellar: :any_skip_relocation, ventura:       "6fadf1ff0ed849a40e2ccc48874cd064ee7afb10764c9c9ae46eca20e71699e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8245c0de72d24f00650ae3362bddbe433f4f2e06f71092634532d3fc8e85fe8"
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