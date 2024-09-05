class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.79.tgz"
  sha256 "5471ac4f6120f9b03c5116b878554f9da8cfc4e012377588f9ecfaf3eda6d07d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9709f1788d990984749dde48e236bd1dfca8e9ed1bd656fe86595b6b59751789"
    sha256 cellar: :any,                 arm64_ventura:  "9709f1788d990984749dde48e236bd1dfca8e9ed1bd656fe86595b6b59751789"
    sha256 cellar: :any,                 arm64_monterey: "9709f1788d990984749dde48e236bd1dfca8e9ed1bd656fe86595b6b59751789"
    sha256 cellar: :any,                 sonoma:         "b03c00ddff8a7faa7bd9b2de4693d5e8aaa1ef483c71fb1106628ce88fbbc555"
    sha256 cellar: :any,                 ventura:        "b03c00ddff8a7faa7bd9b2de4693d5e8aaa1ef483c71fb1106628ce88fbbc555"
    sha256 cellar: :any,                 monterey:       "b03c00ddff8a7faa7bd9b2de4693d5e8aaa1ef483c71fb1106628ce88fbbc555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caabbf1231d125df470f5645f98fe43b4e2290a1577cf6630e6d72ee83c924a4"
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