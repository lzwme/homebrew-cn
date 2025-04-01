class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.8.0.tgz"
  sha256 "46f1b22b05d2422418772d58085e5dc59b5cb4454449630568c6109355b801b6"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55cfd15fd9524bb0ff01c927675d40b736d5213c8e897f9d1e222f9f7d8c0419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55cfd15fd9524bb0ff01c927675d40b736d5213c8e897f9d1e222f9f7d8c0419"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55cfd15fd9524bb0ff01c927675d40b736d5213c8e897f9d1e222f9f7d8c0419"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8e20686c8cfb86f9ef39813c2f4ef54e93de7db3dc7bfdfbea01839d065c343"
    sha256 cellar: :any_skip_relocation, ventura:       "e8e20686c8cfb86f9ef39813c2f4ef54e93de7db3dc7bfdfbea01839d065c343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55cfd15fd9524bb0ff01c927675d40b736d5213c8e897f9d1e222f9f7d8c0419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95c8d0a957876fb29b081b79e58eaa47840582a5d617833c27afcdf469c5e529"
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