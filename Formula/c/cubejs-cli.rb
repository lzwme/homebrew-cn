class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.6.tgz"
  sha256 "757d32783e7ee7ac1a9f7a9000c71c5002aa28d22a73449998c41c8d0e6aeeba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b96be6a7bca48dc1df77754c6c672923ed2ca0dc6e99a513ce406ae7adb01903"
    sha256 cellar: :any,                 arm64_sonoma:  "b96be6a7bca48dc1df77754c6c672923ed2ca0dc6e99a513ce406ae7adb01903"
    sha256 cellar: :any,                 arm64_ventura: "b96be6a7bca48dc1df77754c6c672923ed2ca0dc6e99a513ce406ae7adb01903"
    sha256 cellar: :any,                 sonoma:        "cdaf39d996c7b08ec536ac11598e4d27fa08e290d593d977fdb5eb3d3bc9dbef"
    sha256 cellar: :any,                 ventura:       "cdaf39d996c7b08ec536ac11598e4d27fa08e290d593d977fdb5eb3d3bc9dbef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc8e6f7c04d72c71926f83fd2e4bd7de17e50f21bcb00d919b82cea9015c8a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "157def3515d4995e7292026749116685c32104445edf9dee004eabfff41a5e67"
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