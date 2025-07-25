class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.0.6.tgz"
  sha256 "88ad6fa9481720919e429c10081e102f6b6df0b2257be1c85869d6a96c36cfcc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72f96dc36f20ef65bea9f5f1a25cbd76e1fd9e22b59b13b2aa2addb61f00ca1c"
    sha256 cellar: :any,                 arm64_sonoma:  "72f96dc36f20ef65bea9f5f1a25cbd76e1fd9e22b59b13b2aa2addb61f00ca1c"
    sha256 cellar: :any,                 arm64_ventura: "72f96dc36f20ef65bea9f5f1a25cbd76e1fd9e22b59b13b2aa2addb61f00ca1c"
    sha256 cellar: :any,                 sonoma:        "2d1ee67faa9c6da43358b5b2112df84b4deb7cb85deadc914bda8534bc7698d3"
    sha256 cellar: :any,                 ventura:       "2d1ee67faa9c6da43358b5b2112df84b4deb7cb85deadc914bda8534bc7698d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db47fe5cea6cc9771119ecc65483ee7a679c143b0717e875be04afb37c39bd77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3561e1a9eb8c0d74cb85a703ed56c5cdc337ee62199ea6215994a99d5ebc7705"
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