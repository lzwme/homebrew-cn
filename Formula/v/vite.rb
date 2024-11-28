class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.1.tgz"
  sha256 "8eb41b4221fa9aabae40ee1c2ddafbc7ef51d785d455bc24a38ae24657c86a38"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f1c23b7bb01fcdd529abe2e8145646cfa5971233284a680e3392575846b8049"
    sha256 cellar: :any,                 arm64_sonoma:  "5f1c23b7bb01fcdd529abe2e8145646cfa5971233284a680e3392575846b8049"
    sha256 cellar: :any,                 arm64_ventura: "5f1c23b7bb01fcdd529abe2e8145646cfa5971233284a680e3392575846b8049"
    sha256 cellar: :any,                 sonoma:        "016c9343a3a0292f0c0f8a8ee778f28b0ed6660b5733c62f3d478e06dd680912"
    sha256 cellar: :any,                 ventura:       "016c9343a3a0292f0c0f8a8ee778f28b0ed6660b5733c62f3d478e06dd680912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56f91a540ed63f25e7d9f435409ebe94f175f55c9879e31e904ea668fc28a7ec"
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