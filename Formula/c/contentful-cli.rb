class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.4.5.tgz"
  sha256 "075ae2ed965c9f9110b3bc9198498cbadd3ca948d4e42d732192f1461eb9a01d"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9c15668e5ca3b6af4750c1c80efbe8fd19098b0e8bb9cf39d93381fb03a8e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9c15668e5ca3b6af4750c1c80efbe8fd19098b0e8bb9cf39d93381fb03a8e76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9c15668e5ca3b6af4750c1c80efbe8fd19098b0e8bb9cf39d93381fb03a8e76"
    sha256 cellar: :any_skip_relocation, sonoma:        "00ddda04d0e8955739e6ba576cc9c87f6d68efe92528ef655a46b358c85b5f2d"
    sha256 cellar: :any_skip_relocation, ventura:       "00ddda04d0e8955739e6ba576cc9c87f6d68efe92528ef655a46b358c85b5f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c15668e5ca3b6af4750c1c80efbe8fd19098b0e8bb9cf39d93381fb03a8e76"
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