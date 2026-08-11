class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.18.tgz"
  sha256 "c5d8773c34c5eebb236b264f9ecbdb66134217cd8660c1cfe95b7948a93b55d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d6e800dd249bbc5d7f6666a613768b378a54fe3cf41bffe5b0571174bec1097"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d6e800dd249bbc5d7f6666a613768b378a54fe3cf41bffe5b0571174bec1097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d6e800dd249bbc5d7f6666a613768b378a54fe3cf41bffe5b0571174bec1097"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fc182a40c408bb159d1f36863ac8682d0f32d123b57550a0d5e5ca000bebc19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ac567682fb84ccd643c3caebe3b7bd977e3a57422301cacf2656ba557a76e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac567682fb84ccd643c3caebe3b7bd977e3a57422301cacf2656ba557a76e73"
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