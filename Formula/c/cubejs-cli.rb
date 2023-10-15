require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.4.tgz"
  sha256 "7bd30873ffa2a53b6aee7833a7a2f345e75d039de5bed6de0292971402477a4d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a21d749a0163e4014d25093a99ded9d1ab4e848180427b06fa09b13c39cc226b"
    sha256 cellar: :any, arm64_ventura:  "a21d749a0163e4014d25093a99ded9d1ab4e848180427b06fa09b13c39cc226b"
    sha256 cellar: :any, arm64_monterey: "a21d749a0163e4014d25093a99ded9d1ab4e848180427b06fa09b13c39cc226b"
    sha256 cellar: :any, sonoma:         "2760bfbd4cc3a2c64dae323c53492a2d2531879449b71f95d20f97a61c3ea043"
    sha256 cellar: :any, ventura:        "2760bfbd4cc3a2c64dae323c53492a2d2531879449b71f95d20f97a61c3ea043"
    sha256 cellar: :any, monterey:       "2760bfbd4cc3a2c64dae323c53492a2d2531879449b71f95d20f97a61c3ea043"
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