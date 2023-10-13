require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.2.tgz"
  sha256 "6c424923c267238adab01bb28e90709eadd3af6e03a3f363f8597e42e9ddbdd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "599f15f1d3c8dc1ae6980eb87ed5da8db191734eab22aa8456002ded7daea64b"
    sha256 cellar: :any, arm64_ventura:  "599f15f1d3c8dc1ae6980eb87ed5da8db191734eab22aa8456002ded7daea64b"
    sha256 cellar: :any, arm64_monterey: "599f15f1d3c8dc1ae6980eb87ed5da8db191734eab22aa8456002ded7daea64b"
    sha256 cellar: :any, sonoma:         "15849c69651eca7ea926bfe89b6a2c483ceef258606a80e892a4c967dc236a8f"
    sha256 cellar: :any, ventura:        "15849c69651eca7ea926bfe89b6a2c483ceef258606a80e892a4c967dc236a8f"
    sha256 cellar: :any, monterey:       "15849c69651eca7ea926bfe89b6a2c483ceef258606a80e892a4c967dc236a8f"
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