class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.33.tgz"
  sha256 "0bfb93d2189b4e2c2f170f60e70973ae68ee6174f49ccc2826d3232d71898405"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0cb68ddeb982632c85ecafe832f8b31192c7a668a76ffac8f142073cea68cedd"
    sha256 cellar: :any,                 arm64_sonoma:  "0cb68ddeb982632c85ecafe832f8b31192c7a668a76ffac8f142073cea68cedd"
    sha256 cellar: :any,                 arm64_ventura: "0cb68ddeb982632c85ecafe832f8b31192c7a668a76ffac8f142073cea68cedd"
    sha256 cellar: :any,                 sonoma:        "6b2f544537013434ccb5ac47d5b68e548ba8dda1db5364cbcd6531f839103079"
    sha256 cellar: :any,                 ventura:       "6b2f544537013434ccb5ac47d5b68e548ba8dda1db5364cbcd6531f839103079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d538ebece181d73fe7bd54458a80bd834fe8b7f75028991d3ac58c5dac629dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec68d54a9f6b954781862b187723c59e54043291f126611c8766d9b10fcdc23e"
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