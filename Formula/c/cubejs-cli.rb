class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.14.tgz"
  sha256 "2bf7be2cbe464066ccc1f2f756f64f91347ed26dda04a3687b88b046c97a59cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65100f22221ee96fc2f2e0f25f586e77b70183f0efb979961c1805cbdd7c8380"
    sha256 cellar: :any,                 arm64_sonoma:  "65100f22221ee96fc2f2e0f25f586e77b70183f0efb979961c1805cbdd7c8380"
    sha256 cellar: :any,                 arm64_ventura: "65100f22221ee96fc2f2e0f25f586e77b70183f0efb979961c1805cbdd7c8380"
    sha256 cellar: :any,                 sonoma:        "d0e217e80a5873e7abac1937d9d4dcf924ba0da92aa0521678ce9518a1cf2995"
    sha256 cellar: :any,                 ventura:       "d0e217e80a5873e7abac1937d9d4dcf924ba0da92aa0521678ce9518a1cf2995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8474c068b8e74b0cd4928d4469b5a48628c8bc189342c9192366e2a391fbea1d"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end