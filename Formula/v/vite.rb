class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.2.4.tgz"
  sha256 "e11728b5ee5cd9a5d67e3a544c3126aef532eb52bc53e0759d244d95536ee7e8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d742c2b40a1d8361f753f1bccf6317ea133fdabe00168e5994bd962cd6236bec"
    sha256 cellar: :any,                 arm64_sonoma:  "d742c2b40a1d8361f753f1bccf6317ea133fdabe00168e5994bd962cd6236bec"
    sha256 cellar: :any,                 arm64_ventura: "d742c2b40a1d8361f753f1bccf6317ea133fdabe00168e5994bd962cd6236bec"
    sha256 cellar: :any,                 sonoma:        "cfecc00e2e18098fdaf792118bbd4d0f12ffd3c96f6081c6f37c8bdbebe9c9e4"
    sha256 cellar: :any,                 ventura:       "cfecc00e2e18098fdaf792118bbd4d0f12ffd3c96f6081c6f37c8bdbebe9c9e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b46e4f0d8b60d27fadbd3e698fe66ff7a97ba57cb6f896863c29a80ae861b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49d7f0deb0796fdd56f1ad447660a05cd996fef034b6c88e6494b9b1bbba3ecd"
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