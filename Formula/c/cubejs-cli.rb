require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.36.tgz"
  sha256 "11696edaa3e7ccd2fbdf9c9500e781f182beaf1d54fc84e883a7702c67538b87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "617fca4551ef868a2e5bbf097b460d20007f8c5b41b24b4f05627e698717b663"
    sha256 cellar: :any, arm64_ventura:  "617fca4551ef868a2e5bbf097b460d20007f8c5b41b24b4f05627e698717b663"
    sha256 cellar: :any, arm64_monterey: "617fca4551ef868a2e5bbf097b460d20007f8c5b41b24b4f05627e698717b663"
    sha256 cellar: :any, sonoma:         "3662c543583624b87e5a367612460ee9173136b92f8d1fbf6a386bcb346e0bbe"
    sha256 cellar: :any, ventura:        "3662c543583624b87e5a367612460ee9173136b92f8d1fbf6a386bcb346e0bbe"
    sha256 cellar: :any, monterey:       "3662c543583624b87e5a367612460ee9173136b92f8d1fbf6a386bcb346e0bbe"
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