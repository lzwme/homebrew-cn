require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.21.tgz"
  sha256 "b8a109d309edfa09b79132d062b623450dadec2c83d0ea9bcb0f28de087d9c23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c09200e88aa0979be50936a173e2d0e268357b2a32d3f38743dbdfb2a3847b93"
    sha256 cellar: :any,                 arm64_ventura:  "c09200e88aa0979be50936a173e2d0e268357b2a32d3f38743dbdfb2a3847b93"
    sha256 cellar: :any,                 arm64_monterey: "c09200e88aa0979be50936a173e2d0e268357b2a32d3f38743dbdfb2a3847b93"
    sha256 cellar: :any_skip_relocation, sonoma:         "f84c06feff590bce814ec8b6e354cd8f4794ae0312cb5623b987bcfe461cdf86"
    sha256 cellar: :any_skip_relocation, ventura:        "f84c06feff590bce814ec8b6e354cd8f4794ae0312cb5623b987bcfe461cdf86"
    sha256 cellar: :any_skip_relocation, monterey:       "f84c06feff590bce814ec8b6e354cd8f4794ae0312cb5623b987bcfe461cdf86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12431d3f07f64aced193c767a6a491a5695b6552ffeafe0821c9fb44a3bea764"
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