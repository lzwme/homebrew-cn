require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.41.tgz"
  sha256 "47e8e881c158d90afb4866f6dba2d574e4cf314dd65b7fcdb1aed46b8455a7ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b2fec3a4115946ec69b67114c3ce244ca3c9dbd8e43ad8b706d7d24c1e85c9c7"
    sha256 cellar: :any, arm64_ventura:  "b2fec3a4115946ec69b67114c3ce244ca3c9dbd8e43ad8b706d7d24c1e85c9c7"
    sha256 cellar: :any, arm64_monterey: "b2fec3a4115946ec69b67114c3ce244ca3c9dbd8e43ad8b706d7d24c1e85c9c7"
    sha256 cellar: :any, sonoma:         "4c812053f4a55a083da9bfe8ffeda9f3fa8631f61d272bb63864ee8262df4aaa"
    sha256 cellar: :any, ventura:        "4c812053f4a55a083da9bfe8ffeda9f3fa8631f61d272bb63864ee8262df4aaa"
    sha256 cellar: :any, monterey:       "4c812053f4a55a083da9bfe8ffeda9f3fa8631f61d272bb63864ee8262df4aaa"
  end

  depends_on "node"
  uses_from_macos "zlib"

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