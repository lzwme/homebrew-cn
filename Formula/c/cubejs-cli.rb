class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.31.tgz"
  sha256 "cf37f2cde8450c6c400d27411a704c781ee5f45311c99a7d5803ffff5f1e541c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f91ca1669fdbfe23c4d1e07d78931f6b8912c0ba33160cc939c79032ff641fe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef26fd0cfd443174094f18daa9885c750d01d6b28c04dd7437663d381cfb9359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef26fd0cfd443174094f18daa9885c750d01d6b28c04dd7437663d381cfb9359"
    sha256 cellar: :any_skip_relocation, sonoma:        "00c1030209b0fe459a1d6922455366e88560d05a9d80ee6ce3bd667067f4a7c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67e05a5b1322c1a5b22ebddadba60dafd733401dc091094afc4b3f1add71112d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67e05a5b1322c1a5b22ebddadba60dafd733401dc091094afc4b3f1add71112d"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end