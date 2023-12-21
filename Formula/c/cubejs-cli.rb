require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.39.tgz"
  sha256 "ec23e14f9506600ea7d274a89c1311bb8f9fe4311bcacfc228eb36e4b4ae6ec9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "964be683272b2b5c2ed6f7e6da7e274a5661983e8a50a8ebe499955875ccde4b"
    sha256 cellar: :any, arm64_ventura:  "964be683272b2b5c2ed6f7e6da7e274a5661983e8a50a8ebe499955875ccde4b"
    sha256 cellar: :any, arm64_monterey: "964be683272b2b5c2ed6f7e6da7e274a5661983e8a50a8ebe499955875ccde4b"
    sha256 cellar: :any, sonoma:         "d59ecd7fb6461a7b7583885b419534ed13e95bca0e02e8067f7b86e51f711a19"
    sha256 cellar: :any, ventura:        "d59ecd7fb6461a7b7583885b419534ed13e95bca0e02e8067f7b86e51f711a19"
    sha256 cellar: :any, monterey:       "d59ecd7fb6461a7b7583885b419534ed13e95bca0e02e8067f7b86e51f711a19"
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