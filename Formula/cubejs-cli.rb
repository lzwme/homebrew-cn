require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.14.tgz"
  sha256 "de052a0f1bbf45dcc240078e0dce9cece30f2ff3d2b4d7b191f5856181888941"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb1be1cd8778ebee9d04427db02ce0cd759de0fbcce2377bbe198e5fa3754046"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb1be1cd8778ebee9d04427db02ce0cd759de0fbcce2377bbe198e5fa3754046"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb1be1cd8778ebee9d04427db02ce0cd759de0fbcce2377bbe198e5fa3754046"
    sha256 cellar: :any_skip_relocation, ventura:        "b7f8e2b90466c686e80cf129a8987c19dc51669fb08c54d08c6f0b66305bad76"
    sha256 cellar: :any_skip_relocation, monterey:       "b7f8e2b90466c686e80cf129a8987c19dc51669fb08c54d08c6f0b66305bad76"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7f8e2b90466c686e80cf129a8987c19dc51669fb08c54d08c6f0b66305bad76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb1be1cd8778ebee9d04427db02ce0cd759de0fbcce2377bbe198e5fa3754046"
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