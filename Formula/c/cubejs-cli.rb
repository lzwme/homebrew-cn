class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.15.tgz"
  sha256 "807e0d45d6473307ce8c2685b45828caf598d3401a2fc1965b2278ab375afa74"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5214ef2a0f18629b4c0b8246c99e7924a303f1c1c27c1f51e83d1a65bf9e4783"
    sha256 cellar: :any,                 arm64_sonoma:  "5214ef2a0f18629b4c0b8246c99e7924a303f1c1c27c1f51e83d1a65bf9e4783"
    sha256 cellar: :any,                 arm64_ventura: "5214ef2a0f18629b4c0b8246c99e7924a303f1c1c27c1f51e83d1a65bf9e4783"
    sha256 cellar: :any,                 sonoma:        "e0f16999eaaf7b636508a109c9a1cf1253349e126f1f1bfeffb255197c7ca4db"
    sha256 cellar: :any,                 ventura:       "e0f16999eaaf7b636508a109c9a1cf1253349e126f1f1bfeffb255197c7ca4db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d5562170b9dc265d924158ca2b4a1f5f4afd530be45d6bb90f4a72192e3effa"
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