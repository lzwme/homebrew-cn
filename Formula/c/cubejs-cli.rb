class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.6.tgz"
  sha256 "2efd594b9bd97ff73db2f96a12e1d3dbc739958dd765b9d714b84bee8d8425ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cfdec1013ad2d32be419677f12c3071147044ee87eb59d1551ffe191b2913751"
    sha256 cellar: :any,                 arm64_sonoma:  "cfdec1013ad2d32be419677f12c3071147044ee87eb59d1551ffe191b2913751"
    sha256 cellar: :any,                 arm64_ventura: "cfdec1013ad2d32be419677f12c3071147044ee87eb59d1551ffe191b2913751"
    sha256 cellar: :any,                 sonoma:        "7eafc95e8c102c4a26863bb026844ed993be4b9f8538bc281e71bfd4de8a130e"
    sha256 cellar: :any,                 ventura:       "7eafc95e8c102c4a26863bb026844ed993be4b9f8538bc281e71bfd4de8a130e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af8dd87e159e5d59e10fa41d96ffbdb61893e9adb3086ac85b497c44a874a53"
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