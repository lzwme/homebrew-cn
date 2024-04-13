require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.12.tgz"
  sha256 "41b4220c9636fc59974aed2e05697e0ba8b3ce8c4956086b68eec5bfbdab5254"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ee7b1e194a293281d929bc9804ec8281557e463d36fac9e56158407c4e1361a7"
    sha256 cellar: :any,                 arm64_ventura:  "ee7b1e194a293281d929bc9804ec8281557e463d36fac9e56158407c4e1361a7"
    sha256 cellar: :any,                 arm64_monterey: "ee7b1e194a293281d929bc9804ec8281557e463d36fac9e56158407c4e1361a7"
    sha256 cellar: :any,                 sonoma:         "24bc980e1532f64e8a8bab3be2858fba6907eec9039d7b0db163fc5e4d563785"
    sha256 cellar: :any,                 ventura:        "24bc980e1532f64e8a8bab3be2858fba6907eec9039d7b0db163fc5e4d563785"
    sha256 cellar: :any,                 monterey:       "24bc980e1532f64e8a8bab3be2858fba6907eec9039d7b0db163fc5e4d563785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f1e8d08db2d0edfa283f5f5900be090392a60f8bfda014167bf56d6f49e1c71"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end