class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.0.1.tgz"
  sha256 "754b4b5e772968cb88906cd3ea78a624f9ca17684d0abe05e6df95536596e2a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0020eeb99002c1fa540302f5dd951b91b04b388ef2756f72bf8346e054205f08"
    sha256 cellar: :any,                 arm64_sonoma:  "0020eeb99002c1fa540302f5dd951b91b04b388ef2756f72bf8346e054205f08"
    sha256 cellar: :any,                 arm64_ventura: "0020eeb99002c1fa540302f5dd951b91b04b388ef2756f72bf8346e054205f08"
    sha256 cellar: :any,                 sonoma:        "2ba2eccfaf10f8e0229a1a0b9743650427f00aa82d0f3b61b949dbf32673f081"
    sha256 cellar: :any,                 ventura:       "2ba2eccfaf10f8e0229a1a0b9743650427f00aa82d0f3b61b949dbf32673f081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf2620b4c6f71562706bc70a957ed66665e932ad5a55f51a85aaafc2e908517"
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
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end