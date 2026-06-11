class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.57.tgz"
  sha256 "e92eaccdf25171ec842f7e547d1204d15b3db05e72e192f04dab1844b1118b55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d646da0367f7fbfd7b7c8028c7b2cc6c796a05e878f3fb5edc0dc5833e1ae2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1101f16b57234df9693aac61fdc112fe0f489393080a8734655c4e7072e2d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1101f16b57234df9693aac61fdc112fe0f489393080a8734655c4e7072e2d0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aab6ed34f160c52535d2b201fa1670cb293f0b67bb5053e389769dbe1d0f1d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4af40744f51684dc56c85ea4244d7c1c2cda2020711b31ca11afd567f47f74aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4af40744f51684dc56c85ea4244d7c1c2cda2020711b31ca11afd567f47f74aa"
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