class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.30.tgz"
  sha256 "cb4cc56e872a4735773a8d49cd3c2c7f2ca03195e1d6bafa80434f385dd3df9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "86724ab8c64f93cfeccc0ce671a2f0f083d493008e8105ac7ed0f6cb5348fed0"
    sha256 cellar: :any,                 arm64_sonoma:  "86724ab8c64f93cfeccc0ce671a2f0f083d493008e8105ac7ed0f6cb5348fed0"
    sha256 cellar: :any,                 arm64_ventura: "86724ab8c64f93cfeccc0ce671a2f0f083d493008e8105ac7ed0f6cb5348fed0"
    sha256 cellar: :any,                 sonoma:        "aea83c3900d2bd39a0f9ec5d47caf688fc02f4e132dbba33e5299c2b85e33d10"
    sha256 cellar: :any,                 ventura:       "aea83c3900d2bd39a0f9ec5d47caf688fc02f4e132dbba33e5299c2b85e33d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "076dcfac4a1b5dd1edb6de95cc593b92c6bd85acdb91cd5cee4f8b45133f6f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16dadcf58c6b2b1087bb969a86b100b506550567f0a8301c0e770cb564ac028"
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