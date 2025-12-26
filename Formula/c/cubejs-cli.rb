class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.1.tgz"
  sha256 "d02dd0e84d5355e4fc6ed293d99cc3e5aa812e7a6f1d8b91ed7c39058cc0b928"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc91e93218fc4f51d7a6f95a2098cddc807a600becf5b092a9725776e64ade15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc158996cb2809a27fc2089d103f903ce7279502a4e72c6804c26c3cd8f83868"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc158996cb2809a27fc2089d103f903ce7279502a4e72c6804c26c3cd8f83868"
    sha256 cellar: :any_skip_relocation, sonoma:        "434d3d13c19c0de747f1b9d8659460c4a0f05dee7761f61bf8607e6a0fcb2aca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "089cd64691044ca9f07ee33ba109961f00b5b678a5e239968d174a7442186790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089cd64691044ca9f07ee33ba109961f00b5b678a5e239968d174a7442186790"
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