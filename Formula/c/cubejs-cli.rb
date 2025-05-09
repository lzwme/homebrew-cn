class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.12.tgz"
  sha256 "68edb800176fd15f610d73a69473a803cd599dff49ee29a637d5dccdb1fcb4f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c2ef2e8fe58f1e9196f333e499f3612d7805cd385c9e3437ac30ff2d634e87b"
    sha256 cellar: :any,                 arm64_sonoma:  "4c2ef2e8fe58f1e9196f333e499f3612d7805cd385c9e3437ac30ff2d634e87b"
    sha256 cellar: :any,                 arm64_ventura: "4c2ef2e8fe58f1e9196f333e499f3612d7805cd385c9e3437ac30ff2d634e87b"
    sha256 cellar: :any,                 sonoma:        "3626ae92b4c29f47a93bad21ad0b1b72a8ed845a87cb5a65903e742cc64dfeec"
    sha256 cellar: :any,                 ventura:       "3626ae92b4c29f47a93bad21ad0b1b72a8ed845a87cb5a65903e742cc64dfeec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78316ba73442ccf50afdd044aa4c69048a1346acccca432e71180999b665f5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af1cd4592408e4d66119119cccdf57ed29cfc8af9406310645ea95b702ba96d"
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