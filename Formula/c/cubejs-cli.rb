class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.58.tgz"
  sha256 "98ac287ea759192c0d34a368e2a689b3a20cec082df1e633f7661124334752b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a24e026329ec96374c91442ce0a35866fec76e7164c5a13660fc105d854d4f36"
    sha256 cellar: :any,                 arm64_sonoma:  "a24e026329ec96374c91442ce0a35866fec76e7164c5a13660fc105d854d4f36"
    sha256 cellar: :any,                 arm64_ventura: "a24e026329ec96374c91442ce0a35866fec76e7164c5a13660fc105d854d4f36"
    sha256 cellar: :any,                 sonoma:        "3ebab76b04c9838967265134fce328bdb178cab5bd17aa0a43dcdb85a92f8141"
    sha256 cellar: :any,                 ventura:       "3ebab76b04c9838967265134fce328bdb178cab5bd17aa0a43dcdb85a92f8141"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "deaf1d5428a2a7c589cdcc3ec0cd4c3298e70a2295dc71b3e98e3a016c752bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f5624714cec4e7517024343f385befcfed0d2631a39fa08a60d49124f40f895"
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