class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.71.tgz"
  sha256 "ac636e8b6dd9b0bab9914007fa38f4783f8b0db03577144a003f5da7e3d63cfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "13c784f3af2ed40f491d7995fbc4d345c08966707ddc5042d18277653fdf11ff"
    sha256 cellar: :any,                 arm64_ventura:  "13c784f3af2ed40f491d7995fbc4d345c08966707ddc5042d18277653fdf11ff"
    sha256 cellar: :any,                 arm64_monterey: "13c784f3af2ed40f491d7995fbc4d345c08966707ddc5042d18277653fdf11ff"
    sha256 cellar: :any,                 sonoma:         "2a3a4c8e9ca3d8f63150c36322804a65f32473804fedabf849a93bd537acd34b"
    sha256 cellar: :any,                 ventura:        "2a3a4c8e9ca3d8f63150c36322804a65f32473804fedabf849a93bd537acd34b"
    sha256 cellar: :any,                 monterey:       "2a3a4c8e9ca3d8f63150c36322804a65f32473804fedabf849a93bd537acd34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c42c0d255c19a9057af2ec49e5c26977978abf0d3f8ed8c35e64ebb950c32546"
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