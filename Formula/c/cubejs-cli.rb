class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.76.tgz"
  sha256 "a80ece540249626c24786969fca29ecc903104b0f9e43286479706076222a986"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3c2de97ba7382f5903dc724cf3e84e71787f2492a914da12bf46a33ea8234ef5"
    sha256 cellar: :any,                 arm64_ventura:  "3c2de97ba7382f5903dc724cf3e84e71787f2492a914da12bf46a33ea8234ef5"
    sha256 cellar: :any,                 arm64_monterey: "3c2de97ba7382f5903dc724cf3e84e71787f2492a914da12bf46a33ea8234ef5"
    sha256 cellar: :any,                 sonoma:         "821cbcf6fca8399315de1e86301ff202a3173b7b3551c6305ca84e908cfc5a57"
    sha256 cellar: :any,                 ventura:        "821cbcf6fca8399315de1e86301ff202a3173b7b3551c6305ca84e908cfc5a57"
    sha256 cellar: :any,                 monterey:       "821cbcf6fca8399315de1e86301ff202a3173b7b3551c6305ca84e908cfc5a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "488a79fd4c6a3fc587e1736c327bf6a6736a81cbce88284b89a75c924d13280f"
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
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end