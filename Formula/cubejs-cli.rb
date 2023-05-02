require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.31.tgz"
  sha256 "89a41cf1b82389bba6f507c43d607a30442410eb2a01fcb914be56bd20bea8fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a693503a936ac649d52afad1749c00a01356837f1e97a0bc340cc308d6e73f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a693503a936ac649d52afad1749c00a01356837f1e97a0bc340cc308d6e73f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a693503a936ac649d52afad1749c00a01356837f1e97a0bc340cc308d6e73f7"
    sha256 cellar: :any_skip_relocation, ventura:        "28dff253395bbd965f8151ac02622629b4542a9b6b7325f06c1307dfbf756468"
    sha256 cellar: :any_skip_relocation, monterey:       "28dff253395bbd965f8151ac02622629b4542a9b6b7325f06c1307dfbf756468"
    sha256 cellar: :any_skip_relocation, big_sur:        "28dff253395bbd965f8151ac02622629b4542a9b6b7325f06c1307dfbf756468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a693503a936ac649d52afad1749c00a01356837f1e97a0bc340cc308d6e73f7"
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