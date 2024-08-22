class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.74.tgz"
  sha256 "f6ae3ecdc9b4f2463cbaf44230794ba6708dc259f7ccd982b8ef49020155bef3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4339f478d7ef7aa6a052d75fdcfdc2df9115428376b2960b6595d231c32230d6"
    sha256 cellar: :any,                 arm64_ventura:  "4339f478d7ef7aa6a052d75fdcfdc2df9115428376b2960b6595d231c32230d6"
    sha256 cellar: :any,                 arm64_monterey: "4339f478d7ef7aa6a052d75fdcfdc2df9115428376b2960b6595d231c32230d6"
    sha256 cellar: :any,                 sonoma:         "7dc8d0da92493f5c0a030f723b7eda7bee9eb59678c58e35e951fcafe1db6375"
    sha256 cellar: :any,                 ventura:        "7dc8d0da92493f5c0a030f723b7eda7bee9eb59678c58e35e951fcafe1db6375"
    sha256 cellar: :any,                 monterey:       "7dc8d0da92493f5c0a030f723b7eda7bee9eb59678c58e35e951fcafe1db6375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ee9880105ea732b19e5edf69a28d43826fbaad139072995a3a64efbe54a2196"
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