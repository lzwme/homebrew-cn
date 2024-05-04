require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.29.tgz"
  sha256 "7c22ca0e864d2d01acbabc10215de818784178c0edef452da19131406afd0e8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f5f2e0cba2f910d944bddf8306c38c2d1e7fa013bcbce384bf89294773d04e8c"
    sha256 cellar: :any,                 arm64_ventura:  "f5f2e0cba2f910d944bddf8306c38c2d1e7fa013bcbce384bf89294773d04e8c"
    sha256 cellar: :any,                 arm64_monterey: "f5f2e0cba2f910d944bddf8306c38c2d1e7fa013bcbce384bf89294773d04e8c"
    sha256 cellar: :any,                 sonoma:         "f72498050120c2b9d212aa9e02e3d6c46a1457e342b61549f3169e6acad0e483"
    sha256 cellar: :any,                 ventura:        "f72498050120c2b9d212aa9e02e3d6c46a1457e342b61549f3169e6acad0e483"
    sha256 cellar: :any,                 monterey:       "f72498050120c2b9d212aa9e02e3d6c46a1457e342b61549f3169e6acad0e483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c4fb8f228d4e12dc6f9bb7304ca418182a33bdc135d3cd63b972890f5ad4beb"
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