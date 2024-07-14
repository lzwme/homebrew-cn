require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.59.tgz"
  sha256 "bad553e3f707bb73601b5beebbabe5b1f1d7323641529fd19c638f170c91ac22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b198a89f1f7894a790aacd9a283ebf01a5c0800fd49709700e5eb1c248011b3"
    sha256 cellar: :any,                 arm64_ventura:  "3b198a89f1f7894a790aacd9a283ebf01a5c0800fd49709700e5eb1c248011b3"
    sha256 cellar: :any,                 arm64_monterey: "3b198a89f1f7894a790aacd9a283ebf01a5c0800fd49709700e5eb1c248011b3"
    sha256 cellar: :any,                 sonoma:         "7df86d3aee2acb64960418b8e2498b94bef5f70a57ff06b4c6f6a01db9ef5a7b"
    sha256 cellar: :any,                 ventura:        "7df86d3aee2acb64960418b8e2498b94bef5f70a57ff06b4c6f6a01db9ef5a7b"
    sha256 cellar: :any,                 monterey:       "7df86d3aee2acb64960418b8e2498b94bef5f70a57ff06b4c6f6a01db9ef5a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "409491f6065a0fbec83e8828d059caee03cb2091e008117835957fe85fb5c0ef"
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