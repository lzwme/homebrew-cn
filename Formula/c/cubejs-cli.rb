class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.2.tgz"
  sha256 "f39eb64f3c2aa64f079eaa6e162c44d5e88b6b647abd4a3594330aacb9c1aba9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa1f4e6aac313693c7c5719ceb328ecdd9649974d1cd72408caf0658545fb11b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9af4a4039df281b7e2964ec5527a81e08b79d5e32092bdaa1c9f480d7852c966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af4a4039df281b7e2964ec5527a81e08b79d5e32092bdaa1c9f480d7852c966"
    sha256 cellar: :any_skip_relocation, sonoma:        "7963734ec433edd6e23796b54232651269f9f5b85249c7fd8d45b48da5a5044e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b516f4b841bee3f05fc2378dda1dac3d87828dfce846d37997aa4bebe2167b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b516f4b841bee3f05fc2378dda1dac3d87828dfce846d37997aa4bebe2167b5"
  end

  depends_on "node"
  uses_from_macos "zlib"

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