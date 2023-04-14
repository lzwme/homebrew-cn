require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.26.tgz"
  sha256 "1d2606e02cf51bd56cf9d178c87bd7657da57b4b4bb3a6c95b8ec7095faf92c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a559c66eb90780de8a0af66f49b5eb29cfa88b6e90695d5c9a75a47ae76e9be4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a559c66eb90780de8a0af66f49b5eb29cfa88b6e90695d5c9a75a47ae76e9be4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a559c66eb90780de8a0af66f49b5eb29cfa88b6e90695d5c9a75a47ae76e9be4"
    sha256 cellar: :any_skip_relocation, ventura:        "9ca601401e6141a5c5260e7398cba5038fd1e778e32b9c2446bcbc4d2dbd1946"
    sha256 cellar: :any_skip_relocation, monterey:       "9ca601401e6141a5c5260e7398cba5038fd1e778e32b9c2446bcbc4d2dbd1946"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ca601401e6141a5c5260e7398cba5038fd1e778e32b9c2446bcbc4d2dbd1946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a559c66eb90780de8a0af66f49b5eb29cfa88b6e90695d5c9a75a47ae76e9be4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end