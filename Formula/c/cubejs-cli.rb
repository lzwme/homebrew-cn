class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.27.tgz"
  sha256 "b86ed668cb416995bdc41ffb38f11d339ffd239d709b9a1fff6b1d448666f43a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e5f205a51a9f68295cb0fec543de1a05fe3b8e4f7725227e288917103e28e0b"
    sha256 cellar: :any,                 arm64_sonoma:  "6e5f205a51a9f68295cb0fec543de1a05fe3b8e4f7725227e288917103e28e0b"
    sha256 cellar: :any,                 arm64_ventura: "6e5f205a51a9f68295cb0fec543de1a05fe3b8e4f7725227e288917103e28e0b"
    sha256 cellar: :any,                 sonoma:        "e4cbf9076b407f1073bda78e364d4e4913f9ad74555b817c61df1eb65bf1d013"
    sha256 cellar: :any,                 ventura:       "e4cbf9076b407f1073bda78e364d4e4913f9ad74555b817c61df1eb65bf1d013"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc027a06b64462f0f74faa37ff9ee0489116c6a79ada84d074abdb27ac861783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9279bd7642150aecbadaf0431eddf77732b60212aed03fa6d5f5311175e5175"
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