require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.16.tgz"
  sha256 "0724765d27184ecb1ae2deaa1fedce13e94fd649e14dc6e2067749c0c0f704d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4a875bcc92d00625985f38e41d14386e2fbd14ddb70764821e7306f25b5a8e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4a875bcc92d00625985f38e41d14386e2fbd14ddb70764821e7306f25b5a8e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4a875bcc92d00625985f38e41d14386e2fbd14ddb70764821e7306f25b5a8e8"
    sha256 cellar: :any_skip_relocation, ventura:        "247664f2ec97f449147f08e73c56932669da41120d5c9206590be67c060d270f"
    sha256 cellar: :any_skip_relocation, monterey:       "247664f2ec97f449147f08e73c56932669da41120d5c9206590be67c060d270f"
    sha256 cellar: :any_skip_relocation, big_sur:        "247664f2ec97f449147f08e73c56932669da41120d5c9206590be67c060d270f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a875bcc92d00625985f38e41d14386e2fbd14ddb70764821e7306f25b5a8e8"
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