class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.56.tgz"
  sha256 "7581cab4e5714f1a6a2b7e0bb1e2833526d5f2570e1a2a09621356ffe231857f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "500ec425ab574f35afdb0f457c7494d5c04626a691b59f1bc3536251e76799df"
    sha256 cellar: :any,                 arm64_sonoma:  "500ec425ab574f35afdb0f457c7494d5c04626a691b59f1bc3536251e76799df"
    sha256 cellar: :any,                 arm64_ventura: "500ec425ab574f35afdb0f457c7494d5c04626a691b59f1bc3536251e76799df"
    sha256 cellar: :any,                 sonoma:        "8edd46859f7c89e386ee19737f8138a03f8a50ff9b104efbbea51aaf579a6dc6"
    sha256 cellar: :any,                 ventura:       "8edd46859f7c89e386ee19737f8138a03f8a50ff9b104efbbea51aaf579a6dc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c94b3640febc0fc725e5eb6270f8c566603bfad33cb97bcf2b6aaae0d52b40c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "792ce30fe6415397275ec4657f0b7a340e0858341387bcef9eac28321d5be9e5"
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