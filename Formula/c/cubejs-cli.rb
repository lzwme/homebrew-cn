class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.19.tgz"
  sha256 "ef4612cfaee449b7ef1524a2fb379f31e6b7ea8485e20cc1bf5248ced4fd1c1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb825805528cbeed36e9604c281ad2aebb6af5262486272bc930cec86dbe9191"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e856989c378f0009e8c9311f441c4ffbe1517d54f6062929d60e93cde713207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e856989c378f0009e8c9311f441c4ffbe1517d54f6062929d60e93cde713207"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f1d903a0aa5a4b127dac3da7854b6bca2bff6a00533656a9ac585445b155351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9d3969f3b661f8086cd5f2ad9ab93e57f2229fd363c64d0e3571f3b07a4150c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d3969f3b661f8086cd5f2ad9ab93e57f2229fd363c64d0e3571f3b07a4150c"
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