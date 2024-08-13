class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.69.tgz"
  sha256 "f277059037562308d73b66f4309e4887497d7e5903e4eca1f2e00092952b819f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d51c86251e388b94f7116022213de163f113a52deaf5ba5f617d0145e593d260"
    sha256 cellar: :any,                 arm64_ventura:  "d51c86251e388b94f7116022213de163f113a52deaf5ba5f617d0145e593d260"
    sha256 cellar: :any,                 arm64_monterey: "d51c86251e388b94f7116022213de163f113a52deaf5ba5f617d0145e593d260"
    sha256 cellar: :any,                 sonoma:         "a2612b08fd1cc4ed46a38d90cd0b8c5cf1addf281aad61c1becc35470b45967c"
    sha256 cellar: :any,                 ventura:        "a2612b08fd1cc4ed46a38d90cd0b8c5cf1addf281aad61c1becc35470b45967c"
    sha256 cellar: :any,                 monterey:       "a2612b08fd1cc4ed46a38d90cd0b8c5cf1addf281aad61c1becc35470b45967c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c6513569f4503d90a4cd25fbda4d59d8ca4e8ea54a8ca54a878dcc90ac4e126"
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