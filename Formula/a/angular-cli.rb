require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.0.1.tgz"
  sha256 "ef83a363f50c7f8b0ab28cde603b8b2c0d01532284e24137eae0309f0a9454ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "779ced40ba42c37b276b8222fca8bfc03a2a51878343f50dbfbca3e8a7c51436"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a87bd18327faf6e184c0c275c04794a88d2293df94cb277b4d331e03f46fc8eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "723f94fd918e94a6d9bcdc3598e6e649de1ed3bce640d1ef9202a90636ebe0c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cd1d1f2b865a9d808b556e261b46b0d626870d20a9d180d2e7bfa264c53bc6e"
    sha256 cellar: :any_skip_relocation, ventura:        "c34e88f24414c693cc116376e91cc5146a3d3c5f3f279a88e960d199157d45a9"
    sha256 cellar: :any_skip_relocation, monterey:       "0685acabd7c299cb3a98b2a1ebe01e7aa602373499d57a6e4b91e5ca35420fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be79429b94c52b1bbf2b821967f3f26315a006b6904d62eee48b2864a10011fc"
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