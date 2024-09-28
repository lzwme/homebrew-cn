class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.4.tgz"
  sha256 "c5a0d0b057deb96c567a7a690bbd6b519a5c976d6576d3aa09fae192adf60637"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a1acbffba298ff4242fb5b9e5dacc4526bab90816c6f8cddec0b27e1ebb1506"
    sha256 cellar: :any,                 arm64_sonoma:  "8a1acbffba298ff4242fb5b9e5dacc4526bab90816c6f8cddec0b27e1ebb1506"
    sha256 cellar: :any,                 arm64_ventura: "8a1acbffba298ff4242fb5b9e5dacc4526bab90816c6f8cddec0b27e1ebb1506"
    sha256 cellar: :any,                 sonoma:        "798ae774c893b5a5164d790f75c776cd91bbb3ab22f419f3c012a81fe554b524"
    sha256 cellar: :any,                 ventura:       "798ae774c893b5a5164d790f75c776cd91bbb3ab22f419f3c012a81fe554b524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eed1ecac647574e48a00ba7dbc7e6f45e2b00ac6e2193a40bbaae289f869391"
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