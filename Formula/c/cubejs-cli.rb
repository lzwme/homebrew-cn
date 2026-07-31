class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.14.tgz"
  sha256 "9b66812c6fc53daeaa3735747c02a2df56db8b6205a7382baf7c93180fd67409"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aab8bf937f501f7feb2ea4574459b7ddd8c1dd086fd0b3009251cfa0b83fb25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aab8bf937f501f7feb2ea4574459b7ddd8c1dd086fd0b3009251cfa0b83fb25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aab8bf937f501f7feb2ea4574459b7ddd8c1dd086fd0b3009251cfa0b83fb25"
    sha256 cellar: :any_skip_relocation, sonoma:        "da5f7eba4a84756861f4bb98f910241ca599b53380fd1527b68fdc567b618c83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd7a21925d9167b3c6c7566b8c7ecce34743bafae3660164c8da3a33afc59477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd7a21925d9167b3c6c7566b8c7ecce34743bafae3660164c8da3a33afc59477"
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