class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.11.tgz"
  sha256 "de9741469970053017835db7fe23486cd40f6f59ba4dafa875dda7ffcd640d2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2232a9c01a301c6b82a8b6f3a84ef039c5cda5aafef23fd5fcd9aa1716b7fb5f"
    sha256 cellar: :any,                 arm64_sonoma:  "2232a9c01a301c6b82a8b6f3a84ef039c5cda5aafef23fd5fcd9aa1716b7fb5f"
    sha256 cellar: :any,                 arm64_ventura: "2232a9c01a301c6b82a8b6f3a84ef039c5cda5aafef23fd5fcd9aa1716b7fb5f"
    sha256 cellar: :any,                 sonoma:        "619de0083f36b23f08aa7a8f1bf0a5f22e15b18e77eb13c60b031f26ba200dc7"
    sha256 cellar: :any,                 ventura:       "619de0083f36b23f08aa7a8f1bf0a5f22e15b18e77eb13c60b031f26ba200dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37e5e66fbf70510f63bcf2d57648c06a1fbf117664875253a402ebb235c20455"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end