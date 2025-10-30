class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.0.tgz"
  sha256 "edb24db1254fb6823e9d498976035e98eeab86126d6dfa2c8facd823cee51474"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "deb30778eb9b8331465091bafde74f99f61d65ee8878058bfcfebb597bde0776"
    sha256 cellar: :any,                 arm64_sequoia: "c18dd8fb79109f893d7c6668191b4a6ae6b553ea05f2b7012901f0f4c4ceef52"
    sha256 cellar: :any,                 arm64_sonoma:  "c18dd8fb79109f893d7c6668191b4a6ae6b553ea05f2b7012901f0f4c4ceef52"
    sha256 cellar: :any,                 sonoma:        "ac3d050559ace64b1c43a7ad22fd7a974b0ab68fd1bbd32397fe7f9fdbf1b054"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7c6039d03ab9525d4990e2bcc46a9c3af769f1fbb9e70edb3b7d11708615a05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc64a9e32f6c09d4d0112ff2f6c8735497cf956a9ed54cb71c6beba5652881d"
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