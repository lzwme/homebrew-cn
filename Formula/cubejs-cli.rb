require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.11.tgz"
  sha256 "8fc79ab519ee736e6974cb9eed33fee24766065fb74670a98a7e51cdd3d7bf7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc0637833551082933be4b8ef39cd469eff2b0e51f2e0ce5d1c1daaba3e80e04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc0637833551082933be4b8ef39cd469eff2b0e51f2e0ce5d1c1daaba3e80e04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc0637833551082933be4b8ef39cd469eff2b0e51f2e0ce5d1c1daaba3e80e04"
    sha256 cellar: :any_skip_relocation, ventura:        "a1d2235c0e5e3bbc7cdc686ab881f1638e1df5cc64c7ce5d25b97df3800615f0"
    sha256 cellar: :any_skip_relocation, monterey:       "a1d2235c0e5e3bbc7cdc686ab881f1638e1df5cc64c7ce5d25b97df3800615f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1d2235c0e5e3bbc7cdc686ab881f1638e1df5cc64c7ce5d25b97df3800615f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc0637833551082933be4b8ef39cd469eff2b0e51f2e0ce5d1c1daaba3e80e04"
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