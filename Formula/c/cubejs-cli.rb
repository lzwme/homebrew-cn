require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.42.tgz"
  sha256 "d3a68ed7a572991bc55f045b2452e68c7603fb58742f3f56348d04dea3a3ddb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "73cbf5098706837919d0616dc5cf15dc2fc72bb7c69d1bc7b3910c49408af472"
    sha256 cellar: :any, arm64_ventura:  "73cbf5098706837919d0616dc5cf15dc2fc72bb7c69d1bc7b3910c49408af472"
    sha256 cellar: :any, arm64_monterey: "73cbf5098706837919d0616dc5cf15dc2fc72bb7c69d1bc7b3910c49408af472"
    sha256 cellar: :any, sonoma:         "01cf78beea99b749c033aa3db34eae05469ed34dec31f58292f66e2b16646da7"
    sha256 cellar: :any, ventura:        "01cf78beea99b749c033aa3db34eae05469ed34dec31f58292f66e2b16646da7"
    sha256 cellar: :any, monterey:       "01cf78beea99b749c033aa3db34eae05469ed34dec31f58292f66e2b16646da7"
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