require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.30.tgz"
  sha256 "3f417dfb5c15d422387af16e80e9c1f88a1e36f350d47999cd73906db3900fd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1019d106154fe08b77397d01d7d42db03a58e7c7b4016771a47b7a1253dadf8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1019d106154fe08b77397d01d7d42db03a58e7c7b4016771a47b7a1253dadf8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1019d106154fe08b77397d01d7d42db03a58e7c7b4016771a47b7a1253dadf8e"
    sha256 cellar: :any_skip_relocation, ventura:        "c3f82542daf348c66d55539efb715d0ac73a37624e62fe0f11d5c173f40d342d"
    sha256 cellar: :any_skip_relocation, monterey:       "c3f82542daf348c66d55539efb715d0ac73a37624e62fe0f11d5c173f40d342d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3f82542daf348c66d55539efb715d0ac73a37624e62fe0f11d5c173f40d342d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1019d106154fe08b77397d01d7d42db03a58e7c7b4016771a47b7a1253dadf8e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end