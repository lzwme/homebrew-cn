class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.19.tgz"
  sha256 "f23acd01fe965491efde74e76cf81772b88a7b9a29cc64205a4bc4571e0bb297"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1702534939ce37de260fd93aa2d20299f78eea3c0012c2584c2e7461391bcb35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1702534939ce37de260fd93aa2d20299f78eea3c0012c2584c2e7461391bcb35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1702534939ce37de260fd93aa2d20299f78eea3c0012c2584c2e7461391bcb35"
    sha256 cellar: :any_skip_relocation, sonoma:        "37135a5dd946de5acdaebd7d9fd9d962892731a510d034451ea7b28e67e87583"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c85cffdbee752d6e6a8bccd53d19db4c5063fec9b06e455829dbb458d58d4625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85cffdbee752d6e6a8bccd53d19db4c5063fec9b06e455829dbb458d58d4625"
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