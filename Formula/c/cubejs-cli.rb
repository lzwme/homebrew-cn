require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.18.tgz"
  sha256 "e8b6c5cbe05698b0a2e7fe9ea874190df3c12ec05a35719c987e17d6b22a150a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "54bec24f132b1e704e29787e4cc584457282e2ded1d2bde460cd1a0681cf24dc"
    sha256 cellar: :any,                 arm64_ventura:  "54bec24f132b1e704e29787e4cc584457282e2ded1d2bde460cd1a0681cf24dc"
    sha256 cellar: :any,                 arm64_monterey: "54bec24f132b1e704e29787e4cc584457282e2ded1d2bde460cd1a0681cf24dc"
    sha256 cellar: :any,                 sonoma:         "786470b0a89794e81f94fc88b227ca0638d2fe60c735903b928d5bc97a931a53"
    sha256 cellar: :any,                 ventura:        "786470b0a89794e81f94fc88b227ca0638d2fe60c735903b928d5bc97a931a53"
    sha256 cellar: :any,                 monterey:       "786470b0a89794e81f94fc88b227ca0638d2fe60c735903b928d5bc97a931a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e825f0ee9c18acd04135522b12993a8969e88312ef2636eedb4584071da4eb2"
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