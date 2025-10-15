class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.10.tgz"
  sha256 "50001a2d99d98a819aa4022b0631a94488ec9ee3d0be66e46b58b48d940e4737"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "104824d5217571bd8e8bd18254ca8f806ecfca0d283f97ee4547f996133f48fa"
    sha256 cellar: :any,                 arm64_sequoia: "60783c93d0309118458ee546551248217117bba2c40aaca72878de7dd8853511"
    sha256 cellar: :any,                 arm64_sonoma:  "60783c93d0309118458ee546551248217117bba2c40aaca72878de7dd8853511"
    sha256 cellar: :any,                 sonoma:        "e8655be79dfb70bfbe5b936ee28c4080fa59a2dbf7434135721d46aa61f08197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3e4058a8296a10f01d0a347168ff47eb9ad69686b0abaf1673f23f7146881db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47eabdd46456f20b7bb5c2aa1dc473ce5d8d45e96e3dad7a1bcdc14fc9dcc7f4"
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