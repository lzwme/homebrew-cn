require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.56.tgz"
  sha256 "6511ea641c76107a565355021d97340e60c4e94f4b642300b7df26dbb20a2960"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be9d9cb2bb5cb10ca71a6d069dcb7248c2aa4b004b5272feb5667e1efb4fd43d"
    sha256 cellar: :any,                 arm64_ventura:  "be9d9cb2bb5cb10ca71a6d069dcb7248c2aa4b004b5272feb5667e1efb4fd43d"
    sha256 cellar: :any,                 arm64_monterey: "be9d9cb2bb5cb10ca71a6d069dcb7248c2aa4b004b5272feb5667e1efb4fd43d"
    sha256 cellar: :any,                 sonoma:         "1a5922766273c0d83e6f766c2df2f1863dddf17ae9ed208a265789e4a7fe333e"
    sha256 cellar: :any,                 ventura:        "1a5922766273c0d83e6f766c2df2f1863dddf17ae9ed208a265789e4a7fe333e"
    sha256 cellar: :any,                 monterey:       "10807b86ef9f4f2abc04a97a60061b4a33ee2e90d632d92d32a2261b66af0b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ca730eeff52a205fb224d3b4641e6c940fd0aa8791b226b0617473ebef4586d"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end