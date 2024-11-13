class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.4.tgz"
  sha256 "06caefe2ca3a4db215053e9d88c523a2bdca3035c5f38bc30f726b714ee8cd79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0fa43291f8db9df3c78d2f83d052d6d48b5fb4ee2ea4b8fac440df50ab349dd7"
    sha256 cellar: :any,                 arm64_sonoma:  "0fa43291f8db9df3c78d2f83d052d6d48b5fb4ee2ea4b8fac440df50ab349dd7"
    sha256 cellar: :any,                 arm64_ventura: "0fa43291f8db9df3c78d2f83d052d6d48b5fb4ee2ea4b8fac440df50ab349dd7"
    sha256 cellar: :any,                 sonoma:        "8cfee787eee66ae5d0e751728dba2c4b0a34e6e8602909acf2b6b30974696257"
    sha256 cellar: :any,                 ventura:       "8cfee787eee66ae5d0e751728dba2c4b0a34e6e8602909acf2b6b30974696257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae49e48ce9ea5d0211583056a3828be3e01aa85d5cc482c20eaa4c4173ea6bd7"
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