class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.39.tgz"
  sha256 "50ae88f5a7518e5e5689d12e9500113fb45569673e8d561dab9d4948492c843e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e94a66aa3e9525cfd97ccc9a170de180dd86566030cf594755b70ce50a6f800"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e94a66aa3e9525cfd97ccc9a170de180dd86566030cf594755b70ce50a6f800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e94a66aa3e9525cfd97ccc9a170de180dd86566030cf594755b70ce50a6f800"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4750efbc27a1af56bc395d416ea4f9c3ea6d4cb1e306dba55a99af512d5dbd72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4750efbc27a1af56bc395d416ea4f9c3ea6d4cb1e306dba55a99af512d5dbd72"
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