class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.8.tgz"
  sha256 "0074393b7f7c73fe3dfb601cec5973efe32be666df59dd20c02d8e66d73cc7e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "566421f1114740f1bfb4e32ff589cf59fa266fc3070df33c9520417e7562de33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d507ee47552c7d0d00e246f6294447f1640149a62cd9222847e45203b54f3d00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d507ee47552c7d0d00e246f6294447f1640149a62cd9222847e45203b54f3d00"
    sha256 cellar: :any_skip_relocation, sonoma:        "84d3668e753153eb5ffdd07110b09b9fdd3c10269af0ec999117c7b799bf5c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92d3ffd1aa07ab627e681b1f76ab081a14876b40154bdf40689f2dd19c5928a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d3ffd1aa07ab627e681b1f76ab081a14876b40154bdf40689f2dd19c5928a5"
  end

  depends_on "node"
  uses_from_macos "zlib"

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