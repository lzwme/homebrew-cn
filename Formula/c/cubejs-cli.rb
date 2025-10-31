class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.0.tgz"
  sha256 "edb24db1254fb6823e9d498976035e98eeab86126d6dfa2c8facd823cee51474"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cd14eb70468bdd022fa9e397fa4fd5adc62a4100c34ba55a0122b6546ebf55a"
    sha256 cellar: :any,                 arm64_sequoia: "73f9154253f1dde53db64670631b2327de1940f0641f644e85c73ab86f78adf0"
    sha256 cellar: :any,                 arm64_sonoma:  "73f9154253f1dde53db64670631b2327de1940f0641f644e85c73ab86f78adf0"
    sha256 cellar: :any,                 sonoma:        "39fdb65661ad91b96ca4b6740d502c7a71963f05d3f79426fbead8e71cdff8cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e345fd8f8474d7ed18832fc3dbd3d6cf35bafe634cdb14cec45b746f48ac64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fac7abfd41d6c29dcac92918d73c6a88ba835a83650b27076f5af43906fe98e"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end