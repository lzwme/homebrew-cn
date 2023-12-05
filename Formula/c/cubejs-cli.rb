require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.30.tgz"
  sha256 "456f7110a9b115788109bcf00c031ad31e88e75fe3c1c1539f439f74845249b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "dc8fea1acb288bcebfc275e3525e7db03a3b1ebb14f8b4457e5a0f7baab24918"
    sha256 cellar: :any, arm64_ventura:  "dc8fea1acb288bcebfc275e3525e7db03a3b1ebb14f8b4457e5a0f7baab24918"
    sha256 cellar: :any, arm64_monterey: "dc8fea1acb288bcebfc275e3525e7db03a3b1ebb14f8b4457e5a0f7baab24918"
    sha256 cellar: :any, sonoma:         "18d46a743c0d992478b4bf29badea873a7e6877605c5503f9532b3adc99aad93"
    sha256 cellar: :any, ventura:        "18d46a743c0d992478b4bf29badea873a7e6877605c5503f9532b3adc99aad93"
    sha256 cellar: :any, monterey:       "18d46a743c0d992478b4bf29badea873a7e6877605c5503f9532b3adc99aad93"
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