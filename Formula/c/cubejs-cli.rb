require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.65.tgz"
  sha256 "8124c000d0b05c0a8d354edc2dbb346bee1220eca767da68f17d44866b7d8b57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97ddc9eb7215cc91a67e6bc0473f2f59d088be1b75986ca3df9dd0e0d785e996"
    sha256 cellar: :any,                 arm64_ventura:  "97ddc9eb7215cc91a67e6bc0473f2f59d088be1b75986ca3df9dd0e0d785e996"
    sha256 cellar: :any,                 arm64_monterey: "97ddc9eb7215cc91a67e6bc0473f2f59d088be1b75986ca3df9dd0e0d785e996"
    sha256 cellar: :any,                 sonoma:         "5100bdcb99ad4d58a4e1ca5c49295300af668b8778067f06103a798ad8b13d3a"
    sha256 cellar: :any,                 ventura:        "5100bdcb99ad4d58a4e1ca5c49295300af668b8778067f06103a798ad8b13d3a"
    sha256 cellar: :any,                 monterey:       "5100bdcb99ad4d58a4e1ca5c49295300af668b8778067f06103a798ad8b13d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cba633c629dc33e7b242fb27374fa7eec09320d3f45ad474e5f28fbfc9a9e70d"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end