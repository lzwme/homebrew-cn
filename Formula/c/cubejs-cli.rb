require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.42.tgz"
  sha256 "6c39ba62a405c60c4a408cc036c0882502a3e841c090c0f385fd695ec32e48b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ae090c980665922bbff74b6db8250dbf8705c03f15459cc48d16f211e69dd281"
    sha256 cellar: :any,                 arm64_ventura:  "ae090c980665922bbff74b6db8250dbf8705c03f15459cc48d16f211e69dd281"
    sha256 cellar: :any,                 arm64_monterey: "ae090c980665922bbff74b6db8250dbf8705c03f15459cc48d16f211e69dd281"
    sha256 cellar: :any,                 sonoma:         "4b49c542ea3028479ef8ca58c44e98901425109e4a19e13da14e5e219ab785cf"
    sha256 cellar: :any,                 ventura:        "4b49c542ea3028479ef8ca58c44e98901425109e4a19e13da14e5e219ab785cf"
    sha256 cellar: :any,                 monterey:       "4b49c542ea3028479ef8ca58c44e98901425109e4a19e13da14e5e219ab785cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e34f789e93132d93cd5321f3e47fbf9c7ad7b8ddc6ef59a1c8a14c4ae659fb7"
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