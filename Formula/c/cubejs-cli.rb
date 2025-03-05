class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.16.tgz"
  sha256 "4977d9dfd3c6607099489583fcf2a3445498b72abd16e5627dd5be077122e36a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1d588b5e47c1ca1e72c78dfee8b7610e00248fae867270f59c49b6a63991b38"
    sha256 cellar: :any,                 arm64_sonoma:  "e1d588b5e47c1ca1e72c78dfee8b7610e00248fae867270f59c49b6a63991b38"
    sha256 cellar: :any,                 arm64_ventura: "e1d588b5e47c1ca1e72c78dfee8b7610e00248fae867270f59c49b6a63991b38"
    sha256 cellar: :any,                 sonoma:        "8b9e8eeca21a4a3b7796d2f970b2c37f84e7d44c8aaa81b8158baebbd88ec657"
    sha256 cellar: :any,                 ventura:       "8b9e8eeca21a4a3b7796d2f970b2c37f84e7d44c8aaa81b8158baebbd88ec657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5d8640b7c35ea78ac8a2a2be56ecaca0cd3ac5eb33098723de93fd8765ec100"
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