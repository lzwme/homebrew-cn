class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.50.tgz"
  sha256 "cd3afcea33d7f18184ae9a441a6e02edda94f7189a391e2318ecb198c2dd97c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5320fb84eb060e11df2127e640cfe4e757a4de410b2f4a19c7a2c70e7f46efe8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5320fb84eb060e11df2127e640cfe4e757a4de410b2f4a19c7a2c70e7f46efe8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5320fb84eb060e11df2127e640cfe4e757a4de410b2f4a19c7a2c70e7f46efe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "efca65e1f66b9fc77968285f94f8b9cac0fc9cca145e070aeb90d41c09376823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "efca65e1f66b9fc77968285f94f8b9cac0fc9cca145e070aeb90d41c09376823"
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