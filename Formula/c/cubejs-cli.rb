class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.52.tgz"
  sha256 "9136d7626aa21ebe68156f01ef22d1b1521c20d83b3b31b354dbb71744735796"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73a52ed57e7777721a6cdc1bf325b20b97a5f9d97b422273895e3d7076d51b3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7983babcb4536a52df5fd3f922d75242131b09e2adb640d51341fe87530d6580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7983babcb4536a52df5fd3f922d75242131b09e2adb640d51341fe87530d6580"
    sha256 cellar: :any_skip_relocation, sonoma:        "e500c5ed6ec423796a502377cea9059bed78964221ae282d21cbdf828c6fa5d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d716a8473a71c60420afe270f507abf70b72dfe08cf6a159762932df222383c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d716a8473a71c60420afe270f507abf70b72dfe08cf6a159762932df222383c3"
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