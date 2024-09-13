class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.81.tgz"
  sha256 "b0d37893ef19faf881f33dcc659c6544fa26dbed03747efad44488ba849977b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3d4335b515ecd06b53134a5234757a78d18a762d1154649ed6b196066b9c00cb"
    sha256 cellar: :any,                 arm64_ventura:  "3d4335b515ecd06b53134a5234757a78d18a762d1154649ed6b196066b9c00cb"
    sha256 cellar: :any,                 arm64_monterey: "3d4335b515ecd06b53134a5234757a78d18a762d1154649ed6b196066b9c00cb"
    sha256 cellar: :any,                 sonoma:         "1ec452a5e13efcc13a525ea9d343fc26e8509c4477200544c8b656208a966bd4"
    sha256 cellar: :any,                 ventura:        "1ec452a5e13efcc13a525ea9d343fc26e8509c4477200544c8b656208a966bd4"
    sha256 cellar: :any,                 monterey:       "1ec452a5e13efcc13a525ea9d343fc26e8509c4477200544c8b656208a966bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5064a4aab6c5ae5170ddb79fd64faab8a1e4e078f7f27ec7096c35558cfaac83"
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