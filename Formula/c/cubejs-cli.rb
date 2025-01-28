class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.18.tgz"
  sha256 "81761ccfe837cac50dd3d2cb5cc6af04ee2e82787bd19fe4b73203a50e29a1fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d8dcc4385be5ff33fe289a90024a649d7c93fe011aad9a8264a3b356be700583"
    sha256 cellar: :any,                 arm64_sonoma:  "d8dcc4385be5ff33fe289a90024a649d7c93fe011aad9a8264a3b356be700583"
    sha256 cellar: :any,                 arm64_ventura: "d8dcc4385be5ff33fe289a90024a649d7c93fe011aad9a8264a3b356be700583"
    sha256 cellar: :any,                 sonoma:        "68c9ada4f5adc3492bb976ca7469a4e03ad203079e21942b52007480b626292d"
    sha256 cellar: :any,                 ventura:       "68c9ada4f5adc3492bb976ca7469a4e03ad203079e21942b52007480b626292d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "887537e9443eadbf7e67b4bfe5dd4e32a267f79975e71caa64104222cf50228d"
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
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end