require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.28.tgz"
  sha256 "1a920c93afd88ffcbceb20c6f03d69f6092e5458b319638a6d467c9bbba7b850"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b587ba30f1fad214924cd6f8a43452e73fe9a9f9f001d569588e0f7190aadb4d"
    sha256 cellar: :any,                 arm64_ventura:  "b587ba30f1fad214924cd6f8a43452e73fe9a9f9f001d569588e0f7190aadb4d"
    sha256 cellar: :any,                 arm64_monterey: "b587ba30f1fad214924cd6f8a43452e73fe9a9f9f001d569588e0f7190aadb4d"
    sha256 cellar: :any,                 sonoma:         "81e6b9fc7381324c960c7fc2bbcad709e0ff5b7b6dceaa73c0a070bf5a42c4d6"
    sha256 cellar: :any,                 ventura:        "81e6b9fc7381324c960c7fc2bbcad709e0ff5b7b6dceaa73c0a070bf5a42c4d6"
    sha256 cellar: :any,                 monterey:       "81e6b9fc7381324c960c7fc2bbcad709e0ff5b7b6dceaa73c0a070bf5a42c4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "663653d341cedac1f3281b66ac75d7bdcf28dd44f68683f8bd55f22899570f6f"
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