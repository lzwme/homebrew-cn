class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.0.tgz"
  sha256 "53a66a1e228947413fc19f7f86c3e31a7755645d1573f41fc7aa8df93d6a7c03"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "155dfe1216d2f3ec8c08dd6a4cc39e90e668b59863eee5405b6082f397ea2938"
    sha256 cellar: :any,                 arm64_ventura:  "155dfe1216d2f3ec8c08dd6a4cc39e90e668b59863eee5405b6082f397ea2938"
    sha256 cellar: :any,                 arm64_monterey: "155dfe1216d2f3ec8c08dd6a4cc39e90e668b59863eee5405b6082f397ea2938"
    sha256 cellar: :any,                 sonoma:         "c239932f3d00a032ccc5fb644105292a54603117600b6e0c1af3da588b71a4f3"
    sha256 cellar: :any,                 ventura:        "c239932f3d00a032ccc5fb644105292a54603117600b6e0c1af3da588b71a4f3"
    sha256 cellar: :any,                 monterey:       "c239932f3d00a032ccc5fb644105292a54603117600b6e0c1af3da588b71a4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71788b82fd580981ae1e1cc40c4ba6ff86fd221d77001369b99c08dfb85dccb9"
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