class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.7.tgz"
  sha256 "459c8f113ce1c0f2588790c4ef555b621c1624d8a26d74c43d40f63589879fe6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5cd079329bb2e55caaa8ca4d31a9fd904a38b06bfea425d095a91e010a5bb1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5cd079329bb2e55caaa8ca4d31a9fd904a38b06bfea425d095a91e010a5bb1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5cd079329bb2e55caaa8ca4d31a9fd904a38b06bfea425d095a91e010a5bb1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3b10a01417aa85116a3d2b61c097a814ff75d57c0915194bda2ee92f6a92684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "111fbd6e4a988a0d6538959e828a532f2d56bf5c8e82c11d29a8652f7cb6edc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "111fbd6e4a988a0d6538959e828a532f2d56bf5c8e82c11d29a8652f7cb6edc2"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end