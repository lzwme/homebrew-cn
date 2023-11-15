require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.20.tgz"
  sha256 "63f25e58d21b5fe4b78afc82567f4f3ac4611e7c6987a25be48165f33da5483f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b15e3ddaf32c0ae9826a2984bbb8d0014b5de69f9f0f503358653853273f03ee"
    sha256 cellar: :any, arm64_ventura:  "b15e3ddaf32c0ae9826a2984bbb8d0014b5de69f9f0f503358653853273f03ee"
    sha256 cellar: :any, arm64_monterey: "b15e3ddaf32c0ae9826a2984bbb8d0014b5de69f9f0f503358653853273f03ee"
    sha256 cellar: :any, sonoma:         "38b859193f6c30090325140944bbd9c0d9d8fd4cb322bdc6e39fd512116db533"
    sha256 cellar: :any, ventura:        "38b859193f6c30090325140944bbd9c0d9d8fd4cb322bdc6e39fd512116db533"
    sha256 cellar: :any, monterey:       "38b859193f6c30090325140944bbd9c0d9d8fd4cb322bdc6e39fd512116db533"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end