class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.62.tgz"
  sha256 "6ad4ae9e382945b570d50c1253fa4bd6a40713528b3f0e16f2e7ed252935931f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cef5695e8627f3bad8fac56c9b9000989ebfe6dfd0df390d303a0f4f9a681ff5"
    sha256 cellar: :any,                 arm64_sonoma:  "cef5695e8627f3bad8fac56c9b9000989ebfe6dfd0df390d303a0f4f9a681ff5"
    sha256 cellar: :any,                 arm64_ventura: "cef5695e8627f3bad8fac56c9b9000989ebfe6dfd0df390d303a0f4f9a681ff5"
    sha256 cellar: :any,                 sonoma:        "4b5d9751e24ebae36bf87618cfc0b343a7e9c3d93452b782b4235c7b0b4ff77a"
    sha256 cellar: :any,                 ventura:       "4b5d9751e24ebae36bf87618cfc0b343a7e9c3d93452b782b4235c7b0b4ff77a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "677dbb69bad8714c51b7c3972267ac8e7cd2bd7af9e9324de903ac9b20bf3df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc4b904195e5f0917587671fc731f5d7798d8acf372931b468b2cfbe40ef141"
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