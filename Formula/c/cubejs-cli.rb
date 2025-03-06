class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.17.tgz"
  sha256 "f65b4671183c635deb61b2052304a4d322bbca1c22e9379b4a6f2c12ad2e69c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cef22169e83e88c4a6495c6c8618f0b80a4706da88b1dcb1b566ea33f4936c03"
    sha256 cellar: :any,                 arm64_sonoma:  "cef22169e83e88c4a6495c6c8618f0b80a4706da88b1dcb1b566ea33f4936c03"
    sha256 cellar: :any,                 arm64_ventura: "cef22169e83e88c4a6495c6c8618f0b80a4706da88b1dcb1b566ea33f4936c03"
    sha256 cellar: :any,                 sonoma:        "fb8286d28735b7a46db5acc5841d6251f7d61ab205ca956b5922229c3048a0b4"
    sha256 cellar: :any,                 ventura:       "fb8286d28735b7a46db5acc5841d6251f7d61ab205ca956b5922229c3048a0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea3693e4ce788b5d36e01829422e882a8c742924137a14ec65441416465ac9e"
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