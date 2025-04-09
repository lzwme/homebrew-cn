class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.32.tgz"
  sha256 "f26275b9e6c9a42ee99c2802398ffd5db852599912a1a12b8cdfcef406aed765"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ceda750c97ff35e97b2798c52e7a9b66ea978341292f9a2ed6368c1719c24544"
    sha256 cellar: :any,                 arm64_sonoma:  "ceda750c97ff35e97b2798c52e7a9b66ea978341292f9a2ed6368c1719c24544"
    sha256 cellar: :any,                 arm64_ventura: "ceda750c97ff35e97b2798c52e7a9b66ea978341292f9a2ed6368c1719c24544"
    sha256 cellar: :any,                 sonoma:        "c9bdbb275fa2faaee59152586decc2c3399f6120f9ef287de6496941e6a93f2e"
    sha256 cellar: :any,                 ventura:       "c9bdbb275fa2faaee59152586decc2c3399f6120f9ef287de6496941e6a93f2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6092cfe689fb544375bf33905b7c4ffd41aaeab9d732e0b7f182e3fdf4e40d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2004c5269e330b0f25a0591e3a566e820615910710132922b61895376b76b456"
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
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end