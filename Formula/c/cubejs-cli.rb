require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.40.tgz"
  sha256 "121945ff3b2a18f2897504269decab6606afad06e7d619fd03dc63b0f6c42f1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dba2c86b9729685223eee16f876b1031d51d061ba3179ee69c116864f5f48dd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d0667d8460c7060fc027961656a74751c7acb9dedf5e2b9719c0d4135c1f9b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "208464bbe2482997944d27c839174f0acfc37f84d01e80318affea6e9dc19c23"
    sha256 cellar: :any,                 sonoma:         "ca498ae6f1cf847a2d49288df9099ab03d19445228ec04f6562ddc7edbaf61fa"
    sha256 cellar: :any,                 ventura:        "9980d6d7b128e7a33c10053a90ad1140cdb0597fabbec1c028fb2334385bd8df"
    sha256 cellar: :any,                 monterey:       "ec276cdef2e5742b16225f644005c4d2ee0adf14307283f61d3ff2d1471adfa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a9370e625df5a75a890496faee822ec6ed6b37d05c9c50bc0316fb2c8f5c89e"
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