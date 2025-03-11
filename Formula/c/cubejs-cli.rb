class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.20.tgz"
  sha256 "55682fc11e55539522b9950d25d2a163b3e17c0d0c535b27619e341a5fb0b453"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3a020b3d9932c5282f713f116b5e80ecfc141a08cbbff387942cab616d48b09"
    sha256 cellar: :any,                 arm64_sonoma:  "c3a020b3d9932c5282f713f116b5e80ecfc141a08cbbff387942cab616d48b09"
    sha256 cellar: :any,                 arm64_ventura: "c3a020b3d9932c5282f713f116b5e80ecfc141a08cbbff387942cab616d48b09"
    sha256 cellar: :any,                 sonoma:        "db7780e732c72a06035b8e402917fb35effecb245155cff40f643caa1ad3f932"
    sha256 cellar: :any,                 ventura:       "db7780e732c72a06035b8e402917fb35effecb245155cff40f643caa1ad3f932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e153dd71c4af9a397e217a709b3cdde0db802dc19a64320ab92397a3e3df73a"
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