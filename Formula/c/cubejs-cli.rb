require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.44.tgz"
  sha256 "26699f5bb3da6f92ff9e170d3750f4355067f4d503b40e3b04ba51b52c558d21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ae1ab3df10ba19c25a10bef23f54e0d1ca5b1c6b5e2ed5a60c16f8273dd4e402"
    sha256 cellar: :any,                 arm64_ventura:  "ae1ab3df10ba19c25a10bef23f54e0d1ca5b1c6b5e2ed5a60c16f8273dd4e402"
    sha256 cellar: :any,                 arm64_monterey: "ae1ab3df10ba19c25a10bef23f54e0d1ca5b1c6b5e2ed5a60c16f8273dd4e402"
    sha256 cellar: :any,                 sonoma:         "5e1553ee37c8181f19b4a0fe67eb7b560790825252b3286a4e38dfb4ce560e2f"
    sha256 cellar: :any,                 ventura:        "5e1553ee37c8181f19b4a0fe67eb7b560790825252b3286a4e38dfb4ce560e2f"
    sha256 cellar: :any,                 monterey:       "5e1553ee37c8181f19b4a0fe67eb7b560790825252b3286a4e38dfb4ce560e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03da8f42a1813530922b0beb1432b42e6b0035ff4f550bdd90cee65e4477502c"
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