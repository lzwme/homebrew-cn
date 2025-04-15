class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.1.tgz"
  sha256 "6ad6f9598ba7c068e51e129b797fd89f53ec7b2658d648ec103327d7395927ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a75152f743b2459e8cd38053861cf6cc0667658cddf9c8f88f59ecda6f10df3a"
    sha256 cellar: :any,                 arm64_sonoma:  "a75152f743b2459e8cd38053861cf6cc0667658cddf9c8f88f59ecda6f10df3a"
    sha256 cellar: :any,                 arm64_ventura: "a75152f743b2459e8cd38053861cf6cc0667658cddf9c8f88f59ecda6f10df3a"
    sha256 cellar: :any,                 sonoma:        "762002d86cce22d8df7876523ced4ac14d74d14914f6e0a60df6f320c14cf630"
    sha256 cellar: :any,                 ventura:       "762002d86cce22d8df7876523ced4ac14d74d14914f6e0a60df6f320c14cf630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e5745bc01054c6296c55ac6adef61539906f6fa25eb96c89705a1a0140ed93e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dfe146e652cf816ee11cdc5ae9239c833489124dcf64103590fa06fc3601a45"
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