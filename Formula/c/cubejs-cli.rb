class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.12.tgz"
  sha256 "5c9ba8be42ba2b4de798433e30a38d686cab851a033867e70538ac0646dff0c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b32cedab8cd0daba7ec433284579997812ec978e4711e35e69ce872b66cd2730"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5482f9377a4aa4793632ba30f8147273fd0c90a41f8ab88a5c2f2ab220187dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5482f9377a4aa4793632ba30f8147273fd0c90a41f8ab88a5c2f2ab220187dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba1f6f3d990eef52c3b8a5069adda3f87b433ab1f1a85d6ff8ee98e1af779f10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3a42a699722211ca2fe24b9cc1f676d998d7616f795063a8125e80fe8bad8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a42a699722211ca2fe24b9cc1f676d998d7616f795063a8125e80fe8bad8b4"
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