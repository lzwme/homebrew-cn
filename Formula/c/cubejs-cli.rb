require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.32.tgz"
  sha256 "27b505114cac8e48806d1c6051529ed2e037ca6e8fd50057e18b490e469a2e4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "74310a96e3e75d005b249fed06565ee229535f449723de9d823d19cfa38d33e0"
    sha256 cellar: :any,                 arm64_ventura:  "dd1fb78a5922200b82abf4ad2b2061f3119ab0e9ea409e480955ae9bfd185163"
    sha256 cellar: :any,                 arm64_monterey: "d6607a11580ac65c4390bfbb8aaf09ad065d118a6f0e1113c357953a388c6a13"
    sha256 cellar: :any,                 sonoma:         "28854ab4fd5ed5017e1e29069d326607918b119aff5581075ebf314146fd4796"
    sha256 cellar: :any,                 ventura:        "dac371eb7d33b89e7da4fcc85141a0d015264d90cab520dd66f7855ea2cb1d65"
    sha256 cellar: :any,                 monterey:       "1a31d573a4fa445463945872376adec5381b89135c2f77ed00c52bfec54d2b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a44c64685edea54d9dad7bfec229f74a31831f5c8ebe09fa9b096a3d42bbe802"
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