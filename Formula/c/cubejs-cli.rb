class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.54.tgz"
  sha256 "51f5038b9040b67ef101976beb9ab0973579f081ce78923b918d03be515c94fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97b8b835bc122f1a698534d4d9adf135fa7f605cfe889e041f4a39374e4da147"
    sha256 cellar: :any,                 arm64_sonoma:  "97b8b835bc122f1a698534d4d9adf135fa7f605cfe889e041f4a39374e4da147"
    sha256 cellar: :any,                 arm64_ventura: "97b8b835bc122f1a698534d4d9adf135fa7f605cfe889e041f4a39374e4da147"
    sha256 cellar: :any,                 sonoma:        "d6ecfa01f851b921ff0e32a0c26e0faf2ec858d709b5810a2b96589ab731a228"
    sha256 cellar: :any,                 ventura:       "d6ecfa01f851b921ff0e32a0c26e0faf2ec858d709b5810a2b96589ab731a228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2206b328c21c0681339be5a42df5655dcb8534feb5090b991f96963f717ba1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "606ecd3bc6a38cfcdf13737ac8331712047bef3fc1bdc0f701245ce468971b32"
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