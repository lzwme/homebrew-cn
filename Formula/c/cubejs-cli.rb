class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.73.tgz"
  sha256 "52bf131b4bab30470dff0d24ed8bc38bfa38114b714b19fb13eeffc854131470"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18a2029fc8687bbf2472c73d2c6eb46c4fb7198d3f8a318ae30f538f3243f169"
    sha256 cellar: :any,                 arm64_sequoia: "36cee17e4867194512c20ee78c589d916e2bf81295bfa159ba1885dc599c9097"
    sha256 cellar: :any,                 arm64_sonoma:  "36cee17e4867194512c20ee78c589d916e2bf81295bfa159ba1885dc599c9097"
    sha256 cellar: :any,                 sonoma:        "f4571b903e1109e8e2b0ae729b6e589973f556f4a1a387f5c455479c63b68651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "988f83fa553a15d82d7902c6d36fdd844863231ad353608d470f5473ca08e949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "422a3a60ecd0bc5f8ee444d46ac3482d8835193d6539d9ca808f04789724739c"
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