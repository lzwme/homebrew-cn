class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.2.tgz"
  sha256 "0cf95ac661228303b0067f9e95bdd0cdde0d4227d897a25ad2f62e68b4385439"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2bed047eed94a005b5186cd09e31430c716449d6c1cc1402bc5819ec6c8b907f"
    sha256 cellar: :any,                 arm64_ventura:  "2bed047eed94a005b5186cd09e31430c716449d6c1cc1402bc5819ec6c8b907f"
    sha256 cellar: :any,                 arm64_monterey: "2bed047eed94a005b5186cd09e31430c716449d6c1cc1402bc5819ec6c8b907f"
    sha256 cellar: :any,                 sonoma:         "1ec447831075a9536f8329a1ad25c82d91f4a56b7bec46d91d851f10342b5017"
    sha256 cellar: :any,                 ventura:        "1ec447831075a9536f8329a1ad25c82d91f4a56b7bec46d91d851f10342b5017"
    sha256 cellar: :any,                 monterey:       "1ec447831075a9536f8329a1ad25c82d91f4a56b7bec46d91d851f10342b5017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fb767c187fbe5d87eeae33780465fb394b591205eb932f4ffbdd03c82940d2d"
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