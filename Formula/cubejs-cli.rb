require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.17.tgz"
  sha256 "5b2c7eb92858a29f102fdd246dd6298356a359b34796b907bf92fb14b616e600"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fed5a865bde1b8fb8bf3747030819cfd358735a55c9004d4772e60db30ecfce0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fed5a865bde1b8fb8bf3747030819cfd358735a55c9004d4772e60db30ecfce0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fed5a865bde1b8fb8bf3747030819cfd358735a55c9004d4772e60db30ecfce0"
    sha256 cellar: :any_skip_relocation, ventura:        "539148da8997f3408605ab921f3fc87e49f573d57d209f8bba927204cffde1b7"
    sha256 cellar: :any_skip_relocation, monterey:       "539148da8997f3408605ab921f3fc87e49f573d57d209f8bba927204cffde1b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "539148da8997f3408605ab921f3fc87e49f573d57d209f8bba927204cffde1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fed5a865bde1b8fb8bf3747030819cfd358735a55c9004d4772e60db30ecfce0"
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