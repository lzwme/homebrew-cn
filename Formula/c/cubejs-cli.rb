class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.2.tgz"
  sha256 "bb6c786137120d0936147e928222cff13a72a93d6d1807f5e347a146c177a2dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ea7cf353a5f096ea74d33e7dd62888a51cdfdde21aca97c44c59e752fddafc0"
    sha256 cellar: :any,                 arm64_sequoia: "7bf57912cae4474bc4a71ffd46d53ceb81ba8a4c7f253d24154cc10cfc613660"
    sha256 cellar: :any,                 arm64_sonoma:  "7bf57912cae4474bc4a71ffd46d53ceb81ba8a4c7f253d24154cc10cfc613660"
    sha256 cellar: :any,                 sonoma:        "6e8a4c172d01f2e6fc6b86d97c27a00b6608045bdfa4e17741a0c211ea633391"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b08ad4126b6d19bd95285cbdcd986bf9f54e1419040dd84ef23b5644ce0cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd6fe9dd185fbed38f4d5d596df0e743f8d216f9108ef009e8a1b591b588324"
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