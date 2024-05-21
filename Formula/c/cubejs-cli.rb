require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.37.tgz"
  sha256 "8409c740d31c55c81132698198cc26cdb42f6e16c5378dd5d1661d1aecc4d8a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0681e8b486fdc891dc3bfecec0bf7dca275d301bc5aa9d52668f557713fe3af"
    sha256 cellar: :any,                 arm64_ventura:  "61acd2e1d09b9b36d04206ccdc169df8097615e3d331e674c96a1af75619a800"
    sha256 cellar: :any,                 arm64_monterey: "a69fcfbb1c197702b5cc73c4659fe811089113a2879c83c918025e77b84a3fd2"
    sha256 cellar: :any,                 sonoma:         "758944bae23c3ae065f8ee9d48086f6d70d3895aea521a29650e1a563eb0c78a"
    sha256 cellar: :any,                 ventura:        "d0b25970da657e4ba96c2f958de248170a1097ccedf5021e6c748f422927e28e"
    sha256 cellar: :any,                 monterey:       "0ffa9680791e539b217f758e244c21684914b262a075d2a4abf0b02f759a7c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78d6f3d42ef00ded15ae11abd51dc9f3b4a055a04daa3343f107d1e017803136"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end