class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.11.tgz"
  sha256 "4e106ed534c74e79d0ac2a221adfc60021d1928878e1b0afab5732cc027b3847"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "433956bfba7cee832304a8f7516b32c19492e010948af1fff77679ff7e6913ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40db6fb67a0f5db2042e17ab33fbef70728898dd286cc1f862615d58f64e34aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40db6fb67a0f5db2042e17ab33fbef70728898dd286cc1f862615d58f64e34aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa2d0caae3db50ada5655b78f6e9207b06f01db75b5c77924fddc0c55902d0c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffe632321cc764cd1068cf5680e029d93aeaf34223ed947da72d573d5c6d8a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffe632321cc764cd1068cf5680e029d93aeaf34223ed947da72d573d5c6d8a00"
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