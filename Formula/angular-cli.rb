require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.2.2.tgz"
  sha256 "5a0c47425ce6a50d522f56fa3cd56065a9a47f4be7992bddb8944901e9b53061"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da15f203828ee28556e08d4540a91d552f29bebb7b3441fbb94b0a3c83a43dd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da15f203828ee28556e08d4540a91d552f29bebb7b3441fbb94b0a3c83a43dd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da15f203828ee28556e08d4540a91d552f29bebb7b3441fbb94b0a3c83a43dd0"
    sha256 cellar: :any_skip_relocation, ventura:        "4c334c760c2332151a42dda6299ba42ec793b1bac39215da4381830ebd58f92f"
    sha256 cellar: :any_skip_relocation, monterey:       "4c334c760c2332151a42dda6299ba42ec793b1bac39215da4381830ebd58f92f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c334c760c2332151a42dda6299ba42ec793b1bac39215da4381830ebd58f92f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da15f203828ee28556e08d4540a91d552f29bebb7b3441fbb94b0a3c83a43dd0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end