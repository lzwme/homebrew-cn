class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.50.tgz"
  sha256 "07eba833caeb414bbd8b85ca7c69fda1fcaa3a9083958eb87670650a445cc013"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "057202b5f262ae4395fce67c43fee51acafe504b6b30100ab3029dce629e918d"
    sha256 cellar: :any,                 arm64_sonoma:  "057202b5f262ae4395fce67c43fee51acafe504b6b30100ab3029dce629e918d"
    sha256 cellar: :any,                 arm64_ventura: "057202b5f262ae4395fce67c43fee51acafe504b6b30100ab3029dce629e918d"
    sha256 cellar: :any,                 sonoma:        "efe740ef7e8527b8f5da0825d756be467414f011f0a1085105ae3e9078e07e99"
    sha256 cellar: :any,                 ventura:       "efe740ef7e8527b8f5da0825d756be467414f011f0a1085105ae3e9078e07e99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5f812b8033e82ea5fbc6d0d60b7c602fe25ae4bb5a05adbc1c6051d69869ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "943ae782d7ed938c9734f20007b6216b5e0e7382d3799528c03aa4a8700c86cc"
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