class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.43.tgz"
  sha256 "f391cccb5cca291f783210d4e5a37beb0248b9c454478544f65f3fd5a8d63b1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcf6e477ec7d83f38b06b2c0f41d701172f603b9c723dd3e8fed4d7f730e245b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21492d29c9f917cc99d0100f3ecc2fdfb18f96db0e1f2e7fb166071120f5ec00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21492d29c9f917cc99d0100f3ecc2fdfb18f96db0e1f2e7fb166071120f5ec00"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c7d0031ed4b5806105b52ea980295411ee24f7f8a422c364161f779c48cf86d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1375ae9c0ab2e2b1e19366ebcb34f8140db694d024b5c390f723439c6cfd8fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1375ae9c0ab2e2b1e19366ebcb34f8140db694d024b5c390f723439c6cfd8fa"
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