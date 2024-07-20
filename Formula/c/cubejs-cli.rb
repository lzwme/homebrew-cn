require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.61.tgz"
  sha256 "2a71f1fbb18e5d3e5704a62007825eb41d962473a337a7fddd623db013ff02e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f863e5d97eb076cc00f8cd7ad3045c5deeacedcac6a659238f009595093429a9"
    sha256 cellar: :any,                 arm64_ventura:  "f863e5d97eb076cc00f8cd7ad3045c5deeacedcac6a659238f009595093429a9"
    sha256 cellar: :any,                 arm64_monterey: "f863e5d97eb076cc00f8cd7ad3045c5deeacedcac6a659238f009595093429a9"
    sha256 cellar: :any,                 sonoma:         "9db413a235c76ea44d932f1ea1885b60eef111c223c0e8eedec14af5188b11d3"
    sha256 cellar: :any,                 ventura:        "9db413a235c76ea44d932f1ea1885b60eef111c223c0e8eedec14af5188b11d3"
    sha256 cellar: :any,                 monterey:       "9db413a235c76ea44d932f1ea1885b60eef111c223c0e8eedec14af5188b11d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "997c62e657735e9b3f7025ce5b36afa3ec3ea79d905cff48f2227920b029681e"
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