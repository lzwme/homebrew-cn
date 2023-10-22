require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.6.tgz"
  sha256 "b19be412fd02ca37df35117a8eb3c08bcfd02a37c02b1d3f03e1cc044ded9c33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b54d67ad371c4d61a33540a93203601bc1aca410149ddb6147f745c52685e18b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b54d67ad371c4d61a33540a93203601bc1aca410149ddb6147f745c52685e18b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b54d67ad371c4d61a33540a93203601bc1aca410149ddb6147f745c52685e18b"
    sha256 cellar: :any,                 sonoma:         "65ce1639966518d5d0331132e4c37615b2e3121d051b33af4341a76b2e8f33ae"
    sha256 cellar: :any,                 ventura:        "65ce1639966518d5d0331132e4c37615b2e3121d051b33af4341a76b2e8f33ae"
    sha256 cellar: :any,                 monterey:       "65ce1639966518d5d0331132e4c37615b2e3121d051b33af4341a76b2e8f33ae"
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