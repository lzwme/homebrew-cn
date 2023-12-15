require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.35.tgz"
  sha256 "15d40327d431fd2b20ea9f23deec854df2dbf4c0d09a6bb663fb898be77ae402"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c4a470312679b525258510c4dd531f1c29c3e6b6f9dd6b2473e1609ffa269409"
    sha256 cellar: :any, arm64_ventura:  "c4a470312679b525258510c4dd531f1c29c3e6b6f9dd6b2473e1609ffa269409"
    sha256 cellar: :any, arm64_monterey: "c4a470312679b525258510c4dd531f1c29c3e6b6f9dd6b2473e1609ffa269409"
    sha256 cellar: :any, sonoma:         "8e1e0d5c1de2491a0d56dce535c50e0667c212c3bce6e46abcee3b969fe8e05c"
    sha256 cellar: :any, ventura:        "8e1e0d5c1de2491a0d56dce535c50e0667c212c3bce6e46abcee3b969fe8e05c"
    sha256 cellar: :any, monterey:       "8e1e0d5c1de2491a0d56dce535c50e0667c212c3bce6e46abcee3b969fe8e05c"
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