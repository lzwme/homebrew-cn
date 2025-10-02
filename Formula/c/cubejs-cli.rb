class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.77.tgz"
  sha256 "f42ef9711ab17283c55976e27294242b501d99f863ef6a0da090931d9cc29e8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1155d6dae1520f2efeb6fba35cb6438a36cb38bd6255dc699d280d27979df1d5"
    sha256 cellar: :any,                 arm64_sequoia: "6845a076469a2c4741ec617993fa75e9ecbc56351e207e8bbe9ae313225b093e"
    sha256 cellar: :any,                 arm64_sonoma:  "6845a076469a2c4741ec617993fa75e9ecbc56351e207e8bbe9ae313225b093e"
    sha256 cellar: :any,                 sonoma:        "de2bdf91ecfe7f8b1c13bf29e4c3b1aaa228ec8612c9642e25c9332a8211b528"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e7d7640d1aac67b617eb0930e9516fad1e2d950bd926de3e5997b19723209d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cefa448974e0e8003ecc0e4edb9b53cf089788ea226edcdb19dfba9128c77a9"
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