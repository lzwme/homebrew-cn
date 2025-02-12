class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.4.tgz"
  sha256 "2ceadfc415cb9dbbce14e12b238995ef92229a853e760eb32a9ca1be7d2c3c79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e65d7ee4ffe0f7f83187e4824fe3ac0094b558f3025929f1962a9f8fc3ddc050"
    sha256 cellar: :any,                 arm64_sonoma:  "e65d7ee4ffe0f7f83187e4824fe3ac0094b558f3025929f1962a9f8fc3ddc050"
    sha256 cellar: :any,                 arm64_ventura: "e65d7ee4ffe0f7f83187e4824fe3ac0094b558f3025929f1962a9f8fc3ddc050"
    sha256 cellar: :any,                 sonoma:        "004504d39d40c9363b9acb51ca75be9166bb8dea2945666e12d1a3da20f0d297"
    sha256 cellar: :any,                 ventura:       "004504d39d40c9363b9acb51ca75be9166bb8dea2945666e12d1a3da20f0d297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfe2ec42e5b82dfc5b3e168b48e799389acbd3b80620af7589a7ee0a64c8a8c6"
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