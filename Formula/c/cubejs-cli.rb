class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.40.tgz"
  sha256 "3d064264538848bb6c2d54899e194d40271b4d0e97deb634bf9194e2a3c3a8f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71d98518ca19924b334c4ad26c554e7871309bd262c6272320acf462227602a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71d98518ca19924b334c4ad26c554e7871309bd262c6272320acf462227602a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71d98518ca19924b334c4ad26c554e7871309bd262c6272320acf462227602a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a1536b885abbf4213f2daf41aaa50d85bf1576c3a72214ddf34a7a4ab5a50bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1a1536b885abbf4213f2daf41aaa50d85bf1576c3a72214ddf34a7a4ab5a50bc"
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