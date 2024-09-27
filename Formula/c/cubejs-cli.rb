class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.3.tgz"
  sha256 "e0cc2b9b62b5458da051c4c5222fae9e8f2b7e465b5f1c940a2117431697bd3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f88bc670552d6d894480855577b40ea6913f23c7b22b914cc07b80a1c70aea50"
    sha256 cellar: :any,                 arm64_sonoma:  "f88bc670552d6d894480855577b40ea6913f23c7b22b914cc07b80a1c70aea50"
    sha256 cellar: :any,                 arm64_ventura: "f88bc670552d6d894480855577b40ea6913f23c7b22b914cc07b80a1c70aea50"
    sha256 cellar: :any,                 sonoma:        "b60e6e88d977e17a76f57b26ddbb68bf5cce41a5d1fa12086e3e2b9a68a2daba"
    sha256 cellar: :any,                 ventura:       "b60e6e88d977e17a76f57b26ddbb68bf5cce41a5d1fa12086e3e2b9a68a2daba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a770672be9f3fd394d2db330411d18a52f1754af97b646a79672c9a4a3da996d"
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