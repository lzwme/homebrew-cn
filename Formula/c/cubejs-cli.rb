require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.32.tgz"
  sha256 "aca2e98e5ccfea53fb2cbcea43744433f6f647aaa5e718095cd74bafb56617b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "ea012cdb440aa0e982a7179012c184cf0cff6265a3bbb1a4b8d51d1999653c8e"
    sha256 cellar: :any, arm64_ventura:  "ea012cdb440aa0e982a7179012c184cf0cff6265a3bbb1a4b8d51d1999653c8e"
    sha256 cellar: :any, arm64_monterey: "ea012cdb440aa0e982a7179012c184cf0cff6265a3bbb1a4b8d51d1999653c8e"
    sha256 cellar: :any, sonoma:         "8fb78949923fac0e27f7083ce0c25b4020c340aebad8cd20b296fdc89a3c54b9"
    sha256 cellar: :any, ventura:        "8fb78949923fac0e27f7083ce0c25b4020c340aebad8cd20b296fdc89a3c54b9"
    sha256 cellar: :any, monterey:       "8fb78949923fac0e27f7083ce0c25b4020c340aebad8cd20b296fdc89a3c54b9"
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