require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.3.tgz"
  sha256 "3d01c7aec975d231af5a7e5699ce6011aaab3d9255e6b0d60fee192001f397fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "bd43e6f72695694432e3c293320481650da7c8ae2669457fc8b2deca65e7c2af"
    sha256 cellar: :any, arm64_ventura:  "bd43e6f72695694432e3c293320481650da7c8ae2669457fc8b2deca65e7c2af"
    sha256 cellar: :any, arm64_monterey: "bd43e6f72695694432e3c293320481650da7c8ae2669457fc8b2deca65e7c2af"
    sha256 cellar: :any, sonoma:         "e568704b84a766cab8ba48d20b45a3fc210b9a2469c17bd71c3af664e1f502b1"
    sha256 cellar: :any, ventura:        "e568704b84a766cab8ba48d20b45a3fc210b9a2469c17bd71c3af664e1f502b1"
    sha256 cellar: :any, monterey:       "e568704b84a766cab8ba48d20b45a3fc210b9a2469c17bd71c3af664e1f502b1"
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