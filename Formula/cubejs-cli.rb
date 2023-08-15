require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.46.tgz"
  sha256 "cc8713ccd1c6b99ea1a429d2c392e1979f4b40b2d2fccffd0736bcc381e98ff9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d82d9a6023c8888763c7e326835d839a21725edea8c5405630e9bbd7f0a1df26"
    sha256 cellar: :any, arm64_monterey: "d82d9a6023c8888763c7e326835d839a21725edea8c5405630e9bbd7f0a1df26"
    sha256 cellar: :any, arm64_big_sur:  "d82d9a6023c8888763c7e326835d839a21725edea8c5405630e9bbd7f0a1df26"
    sha256 cellar: :any, ventura:        "b910335a8647573b717acd6aed98a6d64c62b39933dc03d6882cef4aee24ed2f"
    sha256 cellar: :any, monterey:       "b910335a8647573b717acd6aed98a6d64c62b39933dc03d6882cef4aee24ed2f"
    sha256 cellar: :any, big_sur:        "b910335a8647573b717acd6aed98a6d64c62b39933dc03d6882cef4aee24ed2f"
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