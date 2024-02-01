require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.50.tgz"
  sha256 "521c220af80d0fcf44c48b860ec81b75ba2811fc17d58b01240d72526a65faaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f80b9129d38abb29be86aba0b96b9ae7be646837515194337bd49e87d13ce07a"
    sha256 cellar: :any, arm64_ventura:  "f80b9129d38abb29be86aba0b96b9ae7be646837515194337bd49e87d13ce07a"
    sha256 cellar: :any, arm64_monterey: "f80b9129d38abb29be86aba0b96b9ae7be646837515194337bd49e87d13ce07a"
    sha256 cellar: :any, sonoma:         "28353428a01193d7a8ccf44ebe3d86dac0675b13a474ca781432d42a42d87296"
    sha256 cellar: :any, ventura:        "28353428a01193d7a8ccf44ebe3d86dac0675b13a474ca781432d42a42d87296"
    sha256 cellar: :any, monterey:       "28353428a01193d7a8ccf44ebe3d86dac0675b13a474ca781432d42a42d87296"
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