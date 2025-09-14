class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.67.tgz"
  sha256 "c95bc6002cf254a4ae9891dc7665b0e95fa4e41368cce35861c6285123c7c23f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7944a0e41b61a185d3d294c182ab04011912561b9bcd991fcb22294b241d68f1"
    sha256 cellar: :any,                 arm64_sequoia: "5ecc03d479961bad7977366e8bff005f0f610de03fbe431011a3449ea60dc0ef"
    sha256 cellar: :any,                 arm64_sonoma:  "5ecc03d479961bad7977366e8bff005f0f610de03fbe431011a3449ea60dc0ef"
    sha256 cellar: :any,                 arm64_ventura: "5ecc03d479961bad7977366e8bff005f0f610de03fbe431011a3449ea60dc0ef"
    sha256 cellar: :any,                 sonoma:        "2f3fe535c09b3d59bb7f29c0998ab55785a443c3a807364cf94721127bafd588"
    sha256 cellar: :any,                 ventura:       "2f3fe535c09b3d59bb7f29c0998ab55785a443c3a807364cf94721127bafd588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94e6dee293252254cf95b0b13bef12b7d2cad7231ba57e281d405c5e365d22e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acfe84e4bde5e0d5a3ecb15f45bbf266fe961d2ff32b1eaf65268eb1094db4da"
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