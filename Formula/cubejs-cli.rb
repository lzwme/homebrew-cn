require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.5.tgz"
  sha256 "765e09d383e89ef7f820c7bb5fc117c52c54304e4385a4f6ef81f1e5077ea740"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c10f9de8a8a73098c39bb0f14980f38b0b5967b05f15175934c533b1890090b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c10f9de8a8a73098c39bb0f14980f38b0b5967b05f15175934c533b1890090b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c10f9de8a8a73098c39bb0f14980f38b0b5967b05f15175934c533b1890090b"
    sha256 cellar: :any_skip_relocation, ventura:        "0798ed86cb25d96da9bba998b5d434a2c99d158ff4dfc689599ed6d6ce80b88e"
    sha256 cellar: :any_skip_relocation, monterey:       "0798ed86cb25d96da9bba998b5d434a2c99d158ff4dfc689599ed6d6ce80b88e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0798ed86cb25d96da9bba998b5d434a2c99d158ff4dfc689599ed6d6ce80b88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c10f9de8a8a73098c39bb0f14980f38b0b5967b05f15175934c533b1890090b"
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