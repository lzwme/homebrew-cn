class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.80.tgz"
  sha256 "8d9dedb8c4fd6163b46050d37448e5e903329f94af0ea565dacaf99f2615e5cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "836952500d4bcb4d0ce3f07e3272e22ec70097e29634d9e274522893f1c1d2fd"
    sha256 cellar: :any,                 arm64_sonoma:   "b10ed36446e28a1a1f5cca85ad0b5ca4138d4adcb07442bca9ff976f954bb780"
    sha256 cellar: :any,                 arm64_ventura:  "b10ed36446e28a1a1f5cca85ad0b5ca4138d4adcb07442bca9ff976f954bb780"
    sha256 cellar: :any,                 arm64_monterey: "b10ed36446e28a1a1f5cca85ad0b5ca4138d4adcb07442bca9ff976f954bb780"
    sha256 cellar: :any,                 sonoma:         "2348ba8397a9023b4d202b96b56e41907c21efb52b4b25b4375f130b484c2cae"
    sha256 cellar: :any,                 ventura:        "2348ba8397a9023b4d202b96b56e41907c21efb52b4b25b4375f130b484c2cae"
    sha256 cellar: :any,                 monterey:       "2348ba8397a9023b4d202b96b56e41907c21efb52b4b25b4375f130b484c2cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e35ca403c11ce8538f9533fa78a9ebb62262e09b2d1deea391e890446c205bc"
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