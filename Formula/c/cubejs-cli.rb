class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.29.tgz"
  sha256 "4dcefba9cdf1699e9dafa7fc9afbb686aac592d36dad2ae2097adb5f93656004"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e10eb5eeb92470586eb942a8ddcee472b6e7fff1c203c20ff45369a86bdf645"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d004733c5548d719bb9fecb3908d7194675c403e59ddd88db01762197148d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d004733c5548d719bb9fecb3908d7194675c403e59ddd88db01762197148d2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "616130a0615321cb62b89aa43d0b5b9947c46be07b1dd9ea19c6b9ae04fe6ac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4066ef811224aa5aad54ed81322d836545f130f0d196b20bb95ddbb2ce45743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4066ef811224aa5aad54ed81322d836545f130f0d196b20bb95ddbb2ce45743"
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