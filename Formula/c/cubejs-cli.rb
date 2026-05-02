class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.40.tgz"
  sha256 "2a17c5efa585cf2e861ff4a6cc8e610fce9b4dc9ea1bc64ed604ff3e2715c47f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "613779e17f3606d668f8a1838d7ea27bd10fc9ac3127ccafa32be02cea9b0f84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80eed823027e69beb138efa98afc635cf4b0a665bd737ab9ad90732c8e2972ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80eed823027e69beb138efa98afc635cf4b0a665bd737ab9ad90732c8e2972ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "9069491cd103147001ba418a3c54df86fb5f6609338ea133325c1a31c79868ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a8fbb2a87e47a7136d50e3fc3d97b3c553b7728e9ef0e49007ec506b60304e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a8fbb2a87e47a7136d50e3fc3d97b3c553b7728e9ef0e49007ec506b60304e2"
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