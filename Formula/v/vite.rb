class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.2.5.tgz"
  sha256 "9b04e5c1d46d830601d2e2fbf11b2503026b78ea406fd46c9fd6661b38370451"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa39260849586a8fb2b29a3dbb3d389e4e478ba2b095f423719718f21d15666e"
    sha256 cellar: :any,                 arm64_sonoma:  "aa39260849586a8fb2b29a3dbb3d389e4e478ba2b095f423719718f21d15666e"
    sha256 cellar: :any,                 arm64_ventura: "aa39260849586a8fb2b29a3dbb3d389e4e478ba2b095f423719718f21d15666e"
    sha256 cellar: :any,                 sonoma:        "f3e3538962d6b3383ff1f810fe2dcd145078040abfd796158383e10b823d1cd6"
    sha256 cellar: :any,                 ventura:       "f3e3538962d6b3383ff1f810fe2dcd145078040abfd796158383e10b823d1cd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48a77f766ec6dee35e0556589f05b902e9acdba29216a59f819250a381cc0134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c047b1b34881d7a0333a3545316e1b095d637ceb6b035fbff4d427825fe5e13b"
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