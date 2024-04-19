require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.20.tgz"
  sha256 "e3c7b4042a74a5d7c2241b71c99ae4262c1126e8581fd95317c2c036ede11589"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5b6ec3ca9d1a093cad20018d7a68e6bf2c9c4bf8a668bc3dc263ad7b58427d38"
    sha256 cellar: :any,                 arm64_ventura:  "5b6ec3ca9d1a093cad20018d7a68e6bf2c9c4bf8a668bc3dc263ad7b58427d38"
    sha256 cellar: :any,                 arm64_monterey: "5b6ec3ca9d1a093cad20018d7a68e6bf2c9c4bf8a668bc3dc263ad7b58427d38"
    sha256 cellar: :any,                 sonoma:         "c3c65fbb203a17510cdb5ca3aee6e741ba831cea0a238410c333abeb05efdb77"
    sha256 cellar: :any,                 ventura:        "c3c65fbb203a17510cdb5ca3aee6e741ba831cea0a238410c333abeb05efdb77"
    sha256 cellar: :any,                 monterey:       "c3c65fbb203a17510cdb5ca3aee6e741ba831cea0a238410c333abeb05efdb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "657532f4c9e051e6e82ffb79b2a4fa2046d23d3a01d3c0d72bf1b005dd0fa5be"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end