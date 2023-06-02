require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.23.tgz"
  sha256 "0ae8180104bf13bba1a81e37ce35aa6632a5e81a301dfcd6764415844a1f346f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d4d6ad1127318865575f0a03cc65111e05db2aa754c6866ea6a250126342bdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d4d6ad1127318865575f0a03cc65111e05db2aa754c6866ea6a250126342bdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d4d6ad1127318865575f0a03cc65111e05db2aa754c6866ea6a250126342bdc"
    sha256 cellar: :any_skip_relocation, ventura:        "a44ac1ad5869674d55674d19a54e9ba876c51d8d88ad76c44b1ebb27c95e8560"
    sha256 cellar: :any_skip_relocation, monterey:       "a44ac1ad5869674d55674d19a54e9ba876c51d8d88ad76c44b1ebb27c95e8560"
    sha256 cellar: :any_skip_relocation, big_sur:        "a44ac1ad5869674d55674d19a54e9ba876c51d8d88ad76c44b1ebb27c95e8560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d4d6ad1127318865575f0a03cc65111e05db2aa754c6866ea6a250126342bdc"
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