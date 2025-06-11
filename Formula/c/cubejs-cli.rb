class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.21.tgz"
  sha256 "d13577cc6d30660521ca086929dbfb48616d1284fe1d13efefb71fe67269b1b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3470a4d445f932e8d8eea6e7b716f56cde046b2a09de21a6564905e02f48962"
    sha256 cellar: :any,                 arm64_sonoma:  "d3470a4d445f932e8d8eea6e7b716f56cde046b2a09de21a6564905e02f48962"
    sha256 cellar: :any,                 arm64_ventura: "d3470a4d445f932e8d8eea6e7b716f56cde046b2a09de21a6564905e02f48962"
    sha256 cellar: :any,                 sonoma:        "b4ecfbc51259730b3fd53adac11e5de325bc9f6ef777321bf55f3e2e2b50361b"
    sha256 cellar: :any,                 ventura:       "b4ecfbc51259730b3fd53adac11e5de325bc9f6ef777321bf55f3e2e2b50361b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf316e363c22c5860a7c8b600e7034a444e72795920ac85155702a2eaf1e345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb2cd62ab2b8ead6f3a6d45ca738c1a064059af5a6913f0a49798703a365f2aa"
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