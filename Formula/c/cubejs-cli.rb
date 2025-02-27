class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.13.tgz"
  sha256 "0616413712fa54cd4afbf5e3ef17cc66f6c77b7490ed5b466f1abd69e8d01a4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "daf0a72647d589616af7fef45b2dd2f796d4022d1d1f68f141e27baeb6b8e9b9"
    sha256 cellar: :any,                 arm64_sonoma:  "daf0a72647d589616af7fef45b2dd2f796d4022d1d1f68f141e27baeb6b8e9b9"
    sha256 cellar: :any,                 arm64_ventura: "daf0a72647d589616af7fef45b2dd2f796d4022d1d1f68f141e27baeb6b8e9b9"
    sha256 cellar: :any,                 sonoma:        "7fe82d29c987eba9605e4c1490cc97cbd680b6e4d018bafa81ac0fcfc3c55d1c"
    sha256 cellar: :any,                 ventura:       "7fe82d29c987eba9605e4c1490cc97cbd680b6e4d018bafa81ac0fcfc3c55d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ce8a4a3806a98520a0da8632af220186c18b6680b296f98a1bd435e10ef909"
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