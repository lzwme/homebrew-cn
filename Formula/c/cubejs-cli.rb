class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.9.tgz"
  sha256 "8456e1947da93d4c44857faa01ec05435ba739d4ab06d7bea1e737485dc9cb7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a80d5384f4d6c56e79efa262804cd3ddd603e4a208ded7c887b278210b959148"
    sha256 cellar: :any,                 arm64_sonoma:  "a80d5384f4d6c56e79efa262804cd3ddd603e4a208ded7c887b278210b959148"
    sha256 cellar: :any,                 arm64_ventura: "a80d5384f4d6c56e79efa262804cd3ddd603e4a208ded7c887b278210b959148"
    sha256 cellar: :any,                 sonoma:        "59f55d17d90114d48583290a5cf409265446e4f87129e1f9a76e8b3d6c6e8431"
    sha256 cellar: :any,                 ventura:       "59f55d17d90114d48583290a5cf409265446e4f87129e1f9a76e8b3d6c6e8431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26daee28dd74feda98fcbdb586a899c27428aecd0cc485fc32f7a04d062238b5"
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