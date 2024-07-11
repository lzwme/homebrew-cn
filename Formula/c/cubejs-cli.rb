require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.58.tgz"
  sha256 "9a059f81e33425dde30b5a4af45f3040ac154ff036414cda49d94f65f360a46e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da665bff7314d1501234e7000ecf52380cdf8148a6dac401b7ce454b1891d432"
    sha256 cellar: :any,                 arm64_ventura:  "da665bff7314d1501234e7000ecf52380cdf8148a6dac401b7ce454b1891d432"
    sha256 cellar: :any,                 arm64_monterey: "da665bff7314d1501234e7000ecf52380cdf8148a6dac401b7ce454b1891d432"
    sha256 cellar: :any,                 sonoma:         "f54e336b54716c31813b6f2dde94981f9530b91b156ae5172e512351730b7f5f"
    sha256 cellar: :any,                 ventura:        "f54e336b54716c31813b6f2dde94981f9530b91b156ae5172e512351730b7f5f"
    sha256 cellar: :any,                 monterey:       "f54e336b54716c31813b6f2dde94981f9530b91b156ae5172e512351730b7f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "261437f75de01f5ea9bc61f8ab13f618335456350cc8d17a6c40df6cdf4a6145"
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