class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.20.tgz"
  sha256 "d4f2b9ba41fd4a6bf149a208f18834f3fc8cf5f3f02346d9069f559641aceb0e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b20acc139bfb4cbe4d457ebcdf042e041b8b1e9178f7c1dcee8aea3a9e3b0ea0"
    sha256 cellar: :any,                 arm64_sonoma:  "b20acc139bfb4cbe4d457ebcdf042e041b8b1e9178f7c1dcee8aea3a9e3b0ea0"
    sha256 cellar: :any,                 arm64_ventura: "b20acc139bfb4cbe4d457ebcdf042e041b8b1e9178f7c1dcee8aea3a9e3b0ea0"
    sha256 cellar: :any,                 sonoma:        "65e07c41462af90a66b9e70d6286cff5b39b97f3106cf6f493a812307651e144"
    sha256 cellar: :any,                 ventura:       "65e07c41462af90a66b9e70d6286cff5b39b97f3106cf6f493a812307651e144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ea5fa57e03b7230fe9e3a2ae870da52ab3b9d3f32513ead65a4b8a8b7d66fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c38166a838c5baa56341bdce20a209e3d190ac22e5f41fd6a20af2db7d0d72bb"
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