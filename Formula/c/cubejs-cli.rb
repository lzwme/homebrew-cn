class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.14.tgz"
  sha256 "d803ad62c32a47516259b6e7cb69fbb5c195fce00b270e5ecf4b560f1ced4b0a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6befb02cee0f5d89c4360c31d81270ada5d0b75cee1a6dfd90fc87ad9ff5114"
    sha256 cellar: :any,                 arm64_sonoma:  "e6befb02cee0f5d89c4360c31d81270ada5d0b75cee1a6dfd90fc87ad9ff5114"
    sha256 cellar: :any,                 arm64_ventura: "e6befb02cee0f5d89c4360c31d81270ada5d0b75cee1a6dfd90fc87ad9ff5114"
    sha256 cellar: :any,                 sonoma:        "00a96dddf8df47b288eab56fdb2d8e910298ff0e504c6aee4036818be840b885"
    sha256 cellar: :any,                 ventura:       "00a96dddf8df47b288eab56fdb2d8e910298ff0e504c6aee4036818be840b885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8febd3ae930e201de2c942b0a308146915980cab7842bae9d7d028355205b918"
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