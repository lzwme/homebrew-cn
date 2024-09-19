class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.2.tgz"
  sha256 "2e7550562312db60267429fa5e6511ff680a4d0641d1f7f34d1f9af36d8f5249"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a9f8e64f45e04d66b5ce8ab6ee6fe4cb2a93cc72006602668e243715be34d052"
    sha256 cellar: :any,                 arm64_sonoma:  "a9f8e64f45e04d66b5ce8ab6ee6fe4cb2a93cc72006602668e243715be34d052"
    sha256 cellar: :any,                 arm64_ventura: "a9f8e64f45e04d66b5ce8ab6ee6fe4cb2a93cc72006602668e243715be34d052"
    sha256 cellar: :any,                 sonoma:        "b07f2ed8cd6339532826e5090674a169b05140fbf74a40e8264f1fc33dfe6d29"
    sha256 cellar: :any,                 ventura:       "b07f2ed8cd6339532826e5090674a169b05140fbf74a40e8264f1fc33dfe6d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b92f30d8d9a36986bf663748da778abc1b0fcf988b785d260ab1d83c984c7ed"
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