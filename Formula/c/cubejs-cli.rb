require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.7.tgz"
  sha256 "d58448b7fb34d8034b295b9b8a691d00810f464ed4578ffa6c8208422645b50b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c7a8779e6e157faf9621b5d811db99d8f4590aba0d85e099a8199ae80ef6268e"
    sha256 cellar: :any, arm64_ventura:  "c7a8779e6e157faf9621b5d811db99d8f4590aba0d85e099a8199ae80ef6268e"
    sha256 cellar: :any, arm64_monterey: "c7a8779e6e157faf9621b5d811db99d8f4590aba0d85e099a8199ae80ef6268e"
    sha256 cellar: :any, sonoma:         "f9823ac86b9a8886606ac510d4377e616120ca9a8e146dd5ce518adaff1a8a85"
    sha256 cellar: :any, ventura:        "f9823ac86b9a8886606ac510d4377e616120ca9a8e146dd5ce518adaff1a8a85"
    sha256 cellar: :any, monterey:       "f9823ac86b9a8886606ac510d4377e616120ca9a8e146dd5ce518adaff1a8a85"
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