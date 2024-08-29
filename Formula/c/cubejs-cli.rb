class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.78.tgz"
  sha256 "56c550b0a47eb1690a967a7d9324a6f85fc07cc978ec3ba494f5885e0fb9a16d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "18631bf3a9257bfe9a51e2eeb98578674e6a2a208fc7d256ec2c6268043a6e4b"
    sha256 cellar: :any,                 arm64_ventura:  "18631bf3a9257bfe9a51e2eeb98578674e6a2a208fc7d256ec2c6268043a6e4b"
    sha256 cellar: :any,                 arm64_monterey: "18631bf3a9257bfe9a51e2eeb98578674e6a2a208fc7d256ec2c6268043a6e4b"
    sha256 cellar: :any,                 sonoma:         "ac22280515f30ba6f82c8ea7c36a898873fb0da75653fbe2bdab5269ded0ae7a"
    sha256 cellar: :any,                 ventura:        "ac22280515f30ba6f82c8ea7c36a898873fb0da75653fbe2bdab5269ded0ae7a"
    sha256 cellar: :any,                 monterey:       "ac22280515f30ba6f82c8ea7c36a898873fb0da75653fbe2bdab5269ded0ae7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1099cc8984257f6d8694940898f0a54bb5b9785af8a359bc685c8e801e3aa8d"
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