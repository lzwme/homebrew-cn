class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.0.1.tgz"
  sha256 "81a2aa975fc8e55491711048a0f73932863bf286b4f137f84b609b74cb73cfa1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "24b20d953f8a2f0e1e0e05257f6c3d137c15f9b42ad06e272d4244da6d792cc1"
    sha256 cellar: :any,                 arm64_sonoma:  "24b20d953f8a2f0e1e0e05257f6c3d137c15f9b42ad06e272d4244da6d792cc1"
    sha256 cellar: :any,                 arm64_ventura: "24b20d953f8a2f0e1e0e05257f6c3d137c15f9b42ad06e272d4244da6d792cc1"
    sha256 cellar: :any,                 sonoma:        "21129bb501cfc6a86651957325aa4ccb9c3bb0cda7f9dff51020501f923ce1d7"
    sha256 cellar: :any,                 ventura:       "21129bb501cfc6a86651957325aa4ccb9c3bb0cda7f9dff51020501f923ce1d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3af80f7216fd5245bf5e4edef05e4403f58614532323c43ae3f6d873a1cea45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fbda8d2fc418ed93e7ae5bf9eba610b6d298b0bca4914aeb54121f6c92171bd"
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