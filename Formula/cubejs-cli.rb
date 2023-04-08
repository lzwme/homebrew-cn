require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.21.tgz"
  sha256 "6562d02875944036e8a2191f2bb99b79fabf7e9bbce158deb1962a530ee89a93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac96bac50661ca5a4658762fb345badcb2f1fbb89505019300f900cf880a1fa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "490cd78a72203f59213b6f2fc5a4fa73a979013f51bacd2f5d658554f58fc91e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "490cd78a72203f59213b6f2fc5a4fa73a979013f51bacd2f5d658554f58fc91e"
    sha256 cellar: :any_skip_relocation, ventura:        "6a2931421199e894680ad26bd4de9e399eada4acad1d0740bab7065ab673d537"
    sha256 cellar: :any_skip_relocation, monterey:       "6a2931421199e894680ad26bd4de9e399eada4acad1d0740bab7065ab673d537"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a2931421199e894680ad26bd4de9e399eada4acad1d0740bab7065ab673d537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "490cd78a72203f59213b6f2fc5a4fa73a979013f51bacd2f5d658554f58fc91e"
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