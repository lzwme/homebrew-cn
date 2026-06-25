class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.62.tgz"
  sha256 "5a20ef95d709f1f48f6a64f4bdd22f934de81a15876c0817bc254abb12bddfa6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b06a4eea22754c882a601c62a7731432f2619876973ada981e7937e0e10056c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "844b7b03add14e85ac387ad08919f365a11643e53ffe4255a95d800288a85fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "844b7b03add14e85ac387ad08919f365a11643e53ffe4255a95d800288a85fe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fa72879c67cee85d646493418495caf554947fa2bea992aaa1b4a809e5a0974"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccdff2e1fb03354ea1e9ff966ba48e47b9623a256e1f3c65a81ed47654867512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccdff2e1fb03354ea1e9ff966ba48e47b9623a256e1f3c65a81ed47654867512"
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