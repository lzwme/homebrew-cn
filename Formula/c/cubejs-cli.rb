class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.15.tgz"
  sha256 "6423a0bdc63eb09db345af21c7afc633ee593e3373233d581ebbdafa26142b60"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b856d93ec79e4c7767b40233a961043b2e5ba9ee706886b1e1c640da22112ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9da2d5bdd183a56637e727a6394ee65587df6634c70a0de149f08a3d1e03dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9da2d5bdd183a56637e727a6394ee65587df6634c70a0de149f08a3d1e03dc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "478625dacd76b3ed5855776a1804fc29cf5ed2b685d0590d4a2c9be6b01dbfce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a58e391f670057efb5fa1abe46fc9457824a07b39107faf046501eeccdcc4e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a58e391f670057efb5fa1abe46fc9457824a07b39107faf046501eeccdcc4e4a"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end