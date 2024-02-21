require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.56.tgz"
  sha256 "595e3123ad492e3a0844c0b29c1bf83b5a0a782c34407abf46273363db0637f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "bf29894a41443df994e69c87940e87e1076a3de55bbe7c90321f986f23069e87"
    sha256 cellar: :any, arm64_ventura:  "bf29894a41443df994e69c87940e87e1076a3de55bbe7c90321f986f23069e87"
    sha256 cellar: :any, arm64_monterey: "bf29894a41443df994e69c87940e87e1076a3de55bbe7c90321f986f23069e87"
    sha256 cellar: :any, sonoma:         "b60dbdecfa074cfbb9914b0f236fd43951dc0c3ed6a5ddefd1a0fe033211bb53"
    sha256 cellar: :any, ventura:        "b60dbdecfa074cfbb9914b0f236fd43951dc0c3ed6a5ddefd1a0fe033211bb53"
    sha256 cellar: :any, monterey:       "b60dbdecfa074cfbb9914b0f236fd43951dc0c3ed6a5ddefd1a0fe033211bb53"
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