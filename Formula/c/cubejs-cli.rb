class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.46.tgz"
  sha256 "c63e2eb3c92afb86896aac4c2a69ff0b2427a9a78efcbbe67f1d6b5496787f8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5163ce5c4244bf17b4476474e51b25e8ecb2c727cbdc78c215e664caae4b94a8"
    sha256 cellar: :any,                 arm64_sonoma:  "5163ce5c4244bf17b4476474e51b25e8ecb2c727cbdc78c215e664caae4b94a8"
    sha256 cellar: :any,                 arm64_ventura: "5163ce5c4244bf17b4476474e51b25e8ecb2c727cbdc78c215e664caae4b94a8"
    sha256 cellar: :any,                 sonoma:        "8db4bf6c1d5f90229d8adca8246d058aef57f36cdb7bc974a1b3fc957ab9ef38"
    sha256 cellar: :any,                 ventura:       "8db4bf6c1d5f90229d8adca8246d058aef57f36cdb7bc974a1b3fc957ab9ef38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da771a6344baf1aeabd8b5b9b5948414158b28f2b69d0132cf2d54975f88ee6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e3f268d77ff39358a2cdc6b1f1189f7f0a06ba03df00f5cb6f4734f7a92a170"
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