require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.1.tgz"
  sha256 "48091b8c0174a5e0569f1db5f0a11006fdd6f65ea2a4dc33daa8ddb8238faff6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "dc09a586210a71a931b6578b6539e6861b6f9119eaa8fd162dfab29dcb25e5b7"
    sha256 cellar: :any, arm64_ventura:  "dc09a586210a71a931b6578b6539e6861b6f9119eaa8fd162dfab29dcb25e5b7"
    sha256 cellar: :any, arm64_monterey: "dc09a586210a71a931b6578b6539e6861b6f9119eaa8fd162dfab29dcb25e5b7"
    sha256 cellar: :any, sonoma:         "7146d5adffdec41ac7f634157a20f2591b6757592fe0a552423b9038b0667366"
    sha256 cellar: :any, ventura:        "7146d5adffdec41ac7f634157a20f2591b6757592fe0a552423b9038b0667366"
    sha256 cellar: :any, monterey:       "7146d5adffdec41ac7f634157a20f2591b6757592fe0a552423b9038b0667366"
  end

  depends_on "node"

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