class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.3.0.tgz"
  sha256 "bedcd6fae31024cb46aaef7f647f590362a15791a3cb0f54922e7b998343a036"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d651e1ed1e9183715d1800659955c2ab2ec133733394c606ed81bd5b61466187"
    sha256 cellar: :any,                 arm64_sonoma:  "d651e1ed1e9183715d1800659955c2ab2ec133733394c606ed81bd5b61466187"
    sha256 cellar: :any,                 arm64_ventura: "d651e1ed1e9183715d1800659955c2ab2ec133733394c606ed81bd5b61466187"
    sha256 cellar: :any,                 sonoma:        "9b89de9f0d07f113f10ac29f8ebdbc526996e39f5774031021230cb5fa969978"
    sha256 cellar: :any,                 ventura:       "9b89de9f0d07f113f10ac29f8ebdbc526996e39f5774031021230cb5fa969978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd52bf767be8de1b4754dcfd84c184b930bfc16e9a5e09e7f6d392b1c2baf26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "735614712ed2e405aba1c3a12901a66a2f2ee30e0c52b487585d9d2b991c6d17"
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