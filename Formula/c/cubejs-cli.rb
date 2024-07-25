require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.63.tgz"
  sha256 "00c3f812a109ebf5a1896dfb3f9a2ce5c1f9de558b423b25c86471f7023b48fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ef29ce8e5d06df81bece94f99c81180f80eb7d829062d82a7a4dc66ce7202bc"
    sha256 cellar: :any,                 arm64_ventura:  "3ef29ce8e5d06df81bece94f99c81180f80eb7d829062d82a7a4dc66ce7202bc"
    sha256 cellar: :any,                 arm64_monterey: "3ef29ce8e5d06df81bece94f99c81180f80eb7d829062d82a7a4dc66ce7202bc"
    sha256 cellar: :any,                 sonoma:         "170f7ae13a7b86c2eab1d93a717ff4c6c9e7c340dbb6d83e6865f91a4e6d9c33"
    sha256 cellar: :any,                 ventura:        "170f7ae13a7b86c2eab1d93a717ff4c6c9e7c340dbb6d83e6865f91a4e6d9c33"
    sha256 cellar: :any,                 monterey:       "170f7ae13a7b86c2eab1d93a717ff4c6c9e7c340dbb6d83e6865f91a4e6d9c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c11953d4109ac7f889f6a689c6ff5216edfc2518a27bc44b0b2ee5cdc7a943d6"
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