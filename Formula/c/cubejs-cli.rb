class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.28.tgz"
  sha256 "6af56087b81da750d48ff935e4cc78932f552de7c869c493dba3b3f757c1a634"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36c62f1cf823c034ef1a2f98ceff5267be42197e748157f7e64190f0631625a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6d5e6af8bc566bdd31b65fef2ac3e4305f6f561f97e004583fe985bb4cf7c46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6d5e6af8bc566bdd31b65fef2ac3e4305f6f561f97e004583fe985bb4cf7c46"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcdf76d176e2ddaee914702cde204c38eaa25f7e610671782136851349df22b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1434c91bdc0fa1090b0861611b3946da0bbc961db7e23816582ce244fef83e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1434c91bdc0fa1090b0861611b3946da0bbc961db7e23816582ce244fef83e31"
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