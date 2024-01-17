require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.45.tgz"
  sha256 "bdb0e1b67547683a4de33ac400c279eaf6077b8148a527d8ac80b09ef2343749"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "02922d74461d5408a345f2a2b1302948e0d4a2a1b280f6743f1951271ce3d064"
    sha256 cellar: :any, arm64_ventura:  "02922d74461d5408a345f2a2b1302948e0d4a2a1b280f6743f1951271ce3d064"
    sha256 cellar: :any, arm64_monterey: "02922d74461d5408a345f2a2b1302948e0d4a2a1b280f6743f1951271ce3d064"
    sha256 cellar: :any, sonoma:         "1db2a443249d72ffe6624e9b6cfc7bd0ad1c1510a4cdf59baefb29545905e7f3"
    sha256 cellar: :any, ventura:        "1db2a443249d72ffe6624e9b6cfc7bd0ad1c1510a4cdf59baefb29545905e7f3"
    sha256 cellar: :any, monterey:       "1db2a443249d72ffe6624e9b6cfc7bd0ad1c1510a4cdf59baefb29545905e7f3"
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