class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.0.tgz"
  sha256 "de8cae066334c63c4558f808a51be5d7efa26dc93d1ccb201d1e31ca137f417b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "644367bd60efce6a6d5d5f9067d94d4ee4ef7d5b0893a6b6a6c30da629689db6"
    sha256 cellar: :any,                 arm64_sonoma:  "644367bd60efce6a6d5d5f9067d94d4ee4ef7d5b0893a6b6a6c30da629689db6"
    sha256 cellar: :any,                 arm64_ventura: "644367bd60efce6a6d5d5f9067d94d4ee4ef7d5b0893a6b6a6c30da629689db6"
    sha256 cellar: :any,                 sonoma:        "b2f17c241f10bf81026a5237b246b5aef710ac5795ffc84156e0c1c8588bc62f"
    sha256 cellar: :any,                 ventura:       "b2f17c241f10bf81026a5237b246b5aef710ac5795ffc84156e0c1c8588bc62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "284ca2bb760b654dc5486e5ff3b6ea700269f6c8f56fbe16c620978fd428ea42"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end