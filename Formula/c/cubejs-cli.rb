class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.14.tgz"
  sha256 "9e1bceee75c407db759be096952d4fd73d397f727bdf38ae7a4eaf96f581a0ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1dbce2c673ecc2421117b802ae832588f6b6b5272baa5b4cbbe2fd9fe362329f"
    sha256 cellar: :any,                 arm64_sonoma:  "1dbce2c673ecc2421117b802ae832588f6b6b5272baa5b4cbbe2fd9fe362329f"
    sha256 cellar: :any,                 arm64_ventura: "1dbce2c673ecc2421117b802ae832588f6b6b5272baa5b4cbbe2fd9fe362329f"
    sha256 cellar: :any,                 sonoma:        "499bc02fc802f6adae308c510f12e10526ff2cd85f50dbc3276feb7f43dc54b0"
    sha256 cellar: :any,                 ventura:       "499bc02fc802f6adae308c510f12e10526ff2cd85f50dbc3276feb7f43dc54b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3278d8542e151b3f508a98942e5b63b34fae03f1a1627b6b29b3c982fe90b339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "782022ee6f4ed886ca514916350bff3115a02bb14997b1b0c9d9e4bbc5dacc34"
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