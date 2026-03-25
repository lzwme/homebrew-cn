class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.27.tgz"
  sha256 "2a758b926fa86a70065acac33d98140cb208d971b3190db99a3e3d23113ea3fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e8b8c0978a1b7dfb6105215fee4b998d164466f5a1d41ae3d92d3235ff010f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10b64eeb726970c77a4bc744a021180f7e96372e4ace98d3ae3bfa448c2de5e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10b64eeb726970c77a4bc744a021180f7e96372e4ace98d3ae3bfa448c2de5e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "75e7fb882efd37c9a51a834d3912f94530b0d2f53046f784b3fd04162afbcb62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a322d459c8de6b636f5b03de494d962cbfc3a8cd5437b42cf9f3e9999bd83f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a322d459c8de6b636f5b03de494d962cbfc3a8cd5437b42cf9f3e9999bd83f5b"
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