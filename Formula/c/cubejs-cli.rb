class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.13.tgz"
  sha256 "f3b80ef03b02cee4dcba2a872a99a0b875d2a353dbbda395f2aefdcd9043dd44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5dd61cef702e4739892ea7d87162a9059b954ef86bb8b25bcfc511a2cff40548"
    sha256 cellar: :any,                 arm64_sonoma:  "5dd61cef702e4739892ea7d87162a9059b954ef86bb8b25bcfc511a2cff40548"
    sha256 cellar: :any,                 arm64_ventura: "5dd61cef702e4739892ea7d87162a9059b954ef86bb8b25bcfc511a2cff40548"
    sha256 cellar: :any,                 sonoma:        "f12169380cd36f25962bc0d765e416dbbaa33d5764d9d0003d8e797a8dd62740"
    sha256 cellar: :any,                 ventura:       "f12169380cd36f25962bc0d765e416dbbaa33d5764d9d0003d8e797a8dd62740"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf3ad2eeb50e3013ab148a105aa227a1d9eb0296d79021a4dae5f902e4fbdf19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "263f4a7e7b7b0f05dd642d05117df21d14e445151372ca0c56da28d271730d57"
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