class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.59.tgz"
  sha256 "b449d341eadc25b3d722365819c1f7a3511e9d8bf0f167347fb2ac8c390abb93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3d8ed5756cc1ae883acf33dcd285d1ac02fa7cd9cd4b6650aeb48642eec1434"
    sha256 cellar: :any,                 arm64_sonoma:  "b3d8ed5756cc1ae883acf33dcd285d1ac02fa7cd9cd4b6650aeb48642eec1434"
    sha256 cellar: :any,                 arm64_ventura: "b3d8ed5756cc1ae883acf33dcd285d1ac02fa7cd9cd4b6650aeb48642eec1434"
    sha256 cellar: :any,                 sonoma:        "cf12cc14ae750c9faaecaa9969f5c5b9e1240191bb9171069ec2b201ce45d58d"
    sha256 cellar: :any,                 ventura:       "cf12cc14ae750c9faaecaa9969f5c5b9e1240191bb9171069ec2b201ce45d58d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a01cea892dd5ec584eb08b319c01e818b8afc0461c4f161232dbf9c151a62e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c633159ce46f83dc0db8f08e613aac31941d5b487a71530fecf48e1d604698"
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