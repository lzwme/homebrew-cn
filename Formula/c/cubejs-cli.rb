class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.1.tgz"
  sha256 "3a7d63f0afc8d92326215c09e71a8505761de7a8a1639951786b1f8cc5de69dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "488cd10cc888b1451c806a952f66bf641bf915543bf52791828a96d270eac150"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "488cd10cc888b1451c806a952f66bf641bf915543bf52791828a96d270eac150"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "488cd10cc888b1451c806a952f66bf641bf915543bf52791828a96d270eac150"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a3e25353dfee6abf38d4b4a3bfccd6187be4a9effd3dcbd5a2bd1aec12926c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a3e25353dfee6abf38d4b4a3bfccd6187be4a9effd3dcbd5a2bd1aec12926c37"
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