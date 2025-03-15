class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.22.tgz"
  sha256 "aee528c299d5d253475b2c45f98486a957d0463249c2456ca120f660843ce4b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5223047136b2e5af65d3f527f217415ad9c3eb3661e4d6f10416d7850328aeab"
    sha256 cellar: :any,                 arm64_sonoma:  "5223047136b2e5af65d3f527f217415ad9c3eb3661e4d6f10416d7850328aeab"
    sha256 cellar: :any,                 arm64_ventura: "5223047136b2e5af65d3f527f217415ad9c3eb3661e4d6f10416d7850328aeab"
    sha256 cellar: :any,                 sonoma:        "943d372d5069d0df7ba2e86dc9d99381f13c228a0130cc5351db154941991a0a"
    sha256 cellar: :any,                 ventura:       "943d372d5069d0df7ba2e86dc9d99381f13c228a0130cc5351db154941991a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7a77d21ed6570ad18ebfa5c699ebe3fe3349271c627423a3030b25e92256bce"
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