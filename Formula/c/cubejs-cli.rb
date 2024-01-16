require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.44.tgz"
  sha256 "84f21ab66e91d6ef574a21eb3d1882a14a0184b734946ae3fd01861e76bc632f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "03e8657e90c47fac3540065a76dbdc9d0896faf73832248fd24f226ddd6b47a4"
    sha256 cellar: :any, arm64_ventura:  "03e8657e90c47fac3540065a76dbdc9d0896faf73832248fd24f226ddd6b47a4"
    sha256 cellar: :any, arm64_monterey: "03e8657e90c47fac3540065a76dbdc9d0896faf73832248fd24f226ddd6b47a4"
    sha256 cellar: :any, sonoma:         "705f6a697498ea4c6fee91162000bfe663edb49a9715b00d750f4d1758ee5202"
    sha256 cellar: :any, ventura:        "705f6a697498ea4c6fee91162000bfe663edb49a9715b00d750f4d1758ee5202"
    sha256 cellar: :any, monterey:       "705f6a697498ea4c6fee91162000bfe663edb49a9715b00d750f4d1758ee5202"
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