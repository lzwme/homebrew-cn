class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.23.tgz"
  sha256 "d0901c80197d77fe09a37848de26faf79e7691434f9032c72393d8992120921b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "58848f54e468edf7792fb3a1aaf4e18f6451c95abd7ce3289cf4984ff0c2bd86"
    sha256 cellar: :any,                 arm64_sonoma:  "58848f54e468edf7792fb3a1aaf4e18f6451c95abd7ce3289cf4984ff0c2bd86"
    sha256 cellar: :any,                 arm64_ventura: "58848f54e468edf7792fb3a1aaf4e18f6451c95abd7ce3289cf4984ff0c2bd86"
    sha256 cellar: :any,                 sonoma:        "9435ec9d316d21c3938bef88a475a37ec07a6cc01825aef7e59e53a5f962a999"
    sha256 cellar: :any,                 ventura:       "9435ec9d316d21c3938bef88a475a37ec07a6cc01825aef7e59e53a5f962a999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3cde6172708c9359308485ce215193427590a44438263c9e1f7dbc37b048b11"
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