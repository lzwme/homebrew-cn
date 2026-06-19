class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.59.tgz"
  sha256 "63f16fcebca5d73a859b9d03a597e69a9bffde5b792e17f81dd6b9dee0a0f33b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "227cbc61f894783c285cd719d9678cb23d65baf8e78fff72456c886ed2570704"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd1ca0ac16b49e49fcf7c10227cec7658f78925038ad1b021aa377d90eb18947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd1ca0ac16b49e49fcf7c10227cec7658f78925038ad1b021aa377d90eb18947"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeb62d3e3b5d46af8bded20ce0b761ec685bcbc9069e12562eafea766f6f341a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1496c74513459d593afaa1c6f40458a4ea5ed92276d854062e9b7037b4be759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1496c74513459d593afaa1c6f40458a4ea5ed92276d854062e9b7037b4be759"
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