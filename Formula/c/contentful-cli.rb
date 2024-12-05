class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.7.1.tgz"
  sha256 "076db6c7046fc702ff9a3cbb6775e4bc38aafc9c34cf5c265c12f99f22b55939"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "748e968361002f719fe37cb8f3cb9a3d0a0039d1cd74b69e7aa23eaadabd838f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "748e968361002f719fe37cb8f3cb9a3d0a0039d1cd74b69e7aa23eaadabd838f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "748e968361002f719fe37cb8f3cb9a3d0a0039d1cd74b69e7aa23eaadabd838f"
    sha256 cellar: :any_skip_relocation, sonoma:        "958be43cfcec0bbef8411c14cb164d1b41264e3cf2c92aa9148abedce645c3f0"
    sha256 cellar: :any_skip_relocation, ventura:       "958be43cfcec0bbef8411c14cb164d1b41264e3cf2c92aa9148abedce645c3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b3890561b5dc6e84bedec68adfa12cc0266cfd01db35736c7f680f1d6ad8c04"
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