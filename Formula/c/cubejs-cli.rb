require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.60.tgz"
  sha256 "cd4d6c8bfcee4859659cd8de5508da768836ae121b25ff6c827384026dba6075"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e7298cb96fbadb4660a1b800e6dda0f158096bf512bc7a2da383916da79e1913"
    sha256 cellar: :any, arm64_ventura:  "e7298cb96fbadb4660a1b800e6dda0f158096bf512bc7a2da383916da79e1913"
    sha256 cellar: :any, arm64_monterey: "e7298cb96fbadb4660a1b800e6dda0f158096bf512bc7a2da383916da79e1913"
    sha256 cellar: :any, sonoma:         "ee2433f1d0022edba250371ba5523b5779f7ece6ac304577fd8a74eb5a39903d"
    sha256 cellar: :any, ventura:        "ee2433f1d0022edba250371ba5523b5779f7ece6ac304577fd8a74eb5a39903d"
    sha256 cellar: :any, monterey:       "ee2433f1d0022edba250371ba5523b5779f7ece6ac304577fd8a74eb5a39903d"
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