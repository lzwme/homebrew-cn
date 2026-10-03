class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.48.tgz"
  sha256 "0dcc969631d11894c3b12530fa7cf61b3ca5c89ca216ddbdd065dbbf74821c5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf3d49601c6ba3642259f4aec58ae4e4bb4f98792d6b6a1bbfefa0b9510559b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf3d49601c6ba3642259f4aec58ae4e4bb4f98792d6b6a1bbfefa0b9510559b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf3d49601c6ba3642259f4aec58ae4e4bb4f98792d6b6a1bbfefa0b9510559b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cfa1aa7f2c5ff72492c46d1f5d2829c2057cdf01641c9250feeba0c3dc939b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cfa1aa7f2c5ff72492c46d1f5d2829c2057cdf01641c9250feeba0c3dc939b22"
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