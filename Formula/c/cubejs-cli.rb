class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.16.tgz"
  sha256 "76ae2f8658baad732c38402a98a9141c4fe076526928605b5c275fe32cceadb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47d3d98153d38badc03c059faeaa2bd10d8a76604a2ac816d9f693a32f32889d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf97dff986619798185a0c4fce0f7b17e8357fd63cbda0f98ac83fae3b22382"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cf97dff986619798185a0c4fce0f7b17e8357fd63cbda0f98ac83fae3b22382"
    sha256 cellar: :any_skip_relocation, sonoma:        "234d3fac1d4eb2e14fa46c5ee53e267a6b2f199d38c479c6eb37b9b17125508f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aef7285854b24ef66ef74301440bc480fcb20fad7594c8e0bcaa866dce373c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef7285854b24ef66ef74301440bc480fcb20fad7594c8e0bcaa866dce373c1d"
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