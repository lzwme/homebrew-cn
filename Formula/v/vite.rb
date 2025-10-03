class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.8.tgz"
  sha256 "2c359e7218349a160c491f825d05566b71ce443ae92d7772a507cf8e227c4ed3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49ad3b5496e73649071830721d2e842a2a6363433270ef0254d3fd121fe6f8fa"
    sha256 cellar: :any,                 arm64_sequoia: "1df61b40a7db25dae431560c27a31f9248283cdfd8f8eb932df01d39a97376ce"
    sha256 cellar: :any,                 arm64_sonoma:  "1df61b40a7db25dae431560c27a31f9248283cdfd8f8eb932df01d39a97376ce"
    sha256 cellar: :any,                 sonoma:        "7fc0c9b1e509449ca899a014cd158c6f6ecdf15f355a4cefbfa1c440bffe311a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71e1fdc8477b615fe584ea4a646b31ff26e7e2542ec6ae94ccb72a0ab80e746d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14db7e12d9fa816867f3fe97698085019092a62449d0867a5d81f2fcf9b3b1b4"
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