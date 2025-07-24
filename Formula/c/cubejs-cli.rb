class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.42.tgz"
  sha256 "a7d696d3d40a9d5947053e3ebd702d689796923e0bc17333f74f8c020a029074"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a1eb37108eabf426a9f167383837f667d653a05b13edd0898c750647824cbd4"
    sha256 cellar: :any,                 arm64_sonoma:  "0a1eb37108eabf426a9f167383837f667d653a05b13edd0898c750647824cbd4"
    sha256 cellar: :any,                 arm64_ventura: "0a1eb37108eabf426a9f167383837f667d653a05b13edd0898c750647824cbd4"
    sha256 cellar: :any,                 sonoma:        "420ff345680f30a672a9f916860020c84ddcb276a9eec2b15bae9d76e099d72a"
    sha256 cellar: :any,                 ventura:       "420ff345680f30a672a9f916860020c84ddcb276a9eec2b15bae9d76e099d72a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df8d62d748d15524de8b4b24833647f8a283a1a1706e4f8dec65f5e6844db014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d58c3c5ef5c2d46202d6fe35b60c771706040b14b84016bb2cd4eb635470f3f"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end