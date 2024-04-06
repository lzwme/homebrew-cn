require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.8.tgz"
  sha256 "58d70288d882e9a61dfe1196e52b57881d0ef2e488e1785fb60ddd122a9b410d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fab94dad60854e8da67bb13558cd84b1ccf10e258517c4adf89fd375cc7a8f07"
    sha256 cellar: :any,                 arm64_ventura:  "fab94dad60854e8da67bb13558cd84b1ccf10e258517c4adf89fd375cc7a8f07"
    sha256 cellar: :any,                 arm64_monterey: "fab94dad60854e8da67bb13558cd84b1ccf10e258517c4adf89fd375cc7a8f07"
    sha256 cellar: :any,                 sonoma:         "d724ca7a232af4ec0c196d23f626ba4041e7283c871c6fc0c5b2beca912fd28d"
    sha256 cellar: :any,                 ventura:        "d724ca7a232af4ec0c196d23f626ba4041e7283c871c6fc0c5b2beca912fd28d"
    sha256 cellar: :any,                 monterey:       "d724ca7a232af4ec0c196d23f626ba4041e7283c871c6fc0c5b2beca912fd28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "939ee801539eb823c52886ae9554f3e98c40b4f59484860ccfdddb7baaf26b9d"
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