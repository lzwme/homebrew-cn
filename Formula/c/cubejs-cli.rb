class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.85.tgz"
  sha256 "65765a2d24a43f0a295ae37bf2ec76391aa8a53f9ec42653e38f1854197df23b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ea02babb11aba3ba297ed24751d823927b6e0f3d28ea661b4c00c0a7ef0cae0"
    sha256 cellar: :any,                 arm64_sequoia: "b01c4f8a6e994a5bbe8a17de12e68ffca41680e8b712547fd4b8d26e06410155"
    sha256 cellar: :any,                 arm64_sonoma:  "b01c4f8a6e994a5bbe8a17de12e68ffca41680e8b712547fd4b8d26e06410155"
    sha256 cellar: :any,                 sonoma:        "1a25e718a0699c4414870ace243c55796730e1e6e84ddba463ca54950e97df08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f408eca4bac9f4ed58ea763ec3ed908d7c8217b2348aef00ec253f46b4f9aa50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f116831cbef366eace4bed4ab2c2fabe29ce6823071c70996d1afa150f1085bc"
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