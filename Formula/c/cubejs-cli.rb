class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.45.tgz"
  sha256 "4bc96531325d905c5b3c74e93a2429474f65e5b9bd7039aff7e39a56269dea04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cffecd4e0befcf0d66e6b62f262a765139d8f33a0f45f3896a54994593e0ce7e"
    sha256 cellar: :any,                 arm64_sonoma:  "cffecd4e0befcf0d66e6b62f262a765139d8f33a0f45f3896a54994593e0ce7e"
    sha256 cellar: :any,                 arm64_ventura: "cffecd4e0befcf0d66e6b62f262a765139d8f33a0f45f3896a54994593e0ce7e"
    sha256 cellar: :any,                 sonoma:        "759510630ec3e0ec45c24468e0cb3465eb394dc44b6c016397dad1de75866e78"
    sha256 cellar: :any,                 ventura:       "759510630ec3e0ec45c24468e0cb3465eb394dc44b6c016397dad1de75866e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d38682202835265122f5c5437c1a79462ffbd55314768c3906f364c855e8d5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f2049c4ecd37a99993b8c4f2a218b48e98e38bbef5b581cda7d71eaf305b4d"
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