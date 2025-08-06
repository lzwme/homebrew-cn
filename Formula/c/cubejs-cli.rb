class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.47.tgz"
  sha256 "2a52d2ff9bebaa957a690e5e3196c878d6ec16b424d155cc8d7fc105b3867661"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dcd41f1dd7f7eb8567bd3bdb8b4e85951f99d3b812e55a4dc4e76a29c0c5ec87"
    sha256 cellar: :any,                 arm64_sonoma:  "dcd41f1dd7f7eb8567bd3bdb8b4e85951f99d3b812e55a4dc4e76a29c0c5ec87"
    sha256 cellar: :any,                 arm64_ventura: "dcd41f1dd7f7eb8567bd3bdb8b4e85951f99d3b812e55a4dc4e76a29c0c5ec87"
    sha256 cellar: :any,                 sonoma:        "7169983c532aad8c1f169aab7ac6b0fcf6650bc26e2c88019bb0cdec314a36a3"
    sha256 cellar: :any,                 ventura:       "7169983c532aad8c1f169aab7ac6b0fcf6650bc26e2c88019bb0cdec314a36a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a121fae01f751bc9d893fec93689fe487ebedc35ebf143c56b714a5c88176957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2af0bf984d08a7ba940348fdf9b80b285af4cb5aa8eb6f231f4f8dddf597d380"
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