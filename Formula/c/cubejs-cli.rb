class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.36.tgz"
  sha256 "6293d14ceba9d5197a7e7e53c292f35c598f6b8490bedf07f064305a1aa5fd9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42efb025c3357ddb00723bbde2c3709a3d90de045097974274dcdcd54cfb4a8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42efb025c3357ddb00723bbde2c3709a3d90de045097974274dcdcd54cfb4a8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42efb025c3357ddb00723bbde2c3709a3d90de045097974274dcdcd54cfb4a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "181673fa67bf6aac5a215d2f037d2b943a96ce04d66a0c96905f2ac84581af90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181673fa67bf6aac5a215d2f037d2b943a96ce04d66a0c96905f2ac84581af90"
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