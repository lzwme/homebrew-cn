require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.8.tgz"
  sha256 "058414034875e9123b7d43903a4b309b7200ccd1c20324b587c58336d5809e45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c1d964205634f589d8e8e0636b477ad04ca1c83328b29e6f649880bf8013b84a"
    sha256 cellar: :any, arm64_ventura:  "c1d964205634f589d8e8e0636b477ad04ca1c83328b29e6f649880bf8013b84a"
    sha256 cellar: :any, arm64_monterey: "c1d964205634f589d8e8e0636b477ad04ca1c83328b29e6f649880bf8013b84a"
    sha256 cellar: :any, sonoma:         "5527cc055008643a6680f1735ef29b2fd00a2f163ec87bfa1da42cd1fd0d3d50"
    sha256 cellar: :any, ventura:        "5527cc055008643a6680f1735ef29b2fd00a2f163ec87bfa1da42cd1fd0d3d50"
    sha256 cellar: :any, monterey:       "5527cc055008643a6680f1735ef29b2fd00a2f163ec87bfa1da42cd1fd0d3d50"
  end

  depends_on "node"

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