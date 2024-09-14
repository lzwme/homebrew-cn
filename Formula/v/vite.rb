class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.5.tgz"
  sha256 "4845b0643dbb8b35708701118dd2f97fbec84f934fb414f07bd92a1f396cb73b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "afd2fa2143d779b048bfe077d7b66e6e713c13e3f631d35dbc21b0aff8544a51"
    sha256 cellar: :any,                 arm64_sonoma:  "afd2fa2143d779b048bfe077d7b66e6e713c13e3f631d35dbc21b0aff8544a51"
    sha256 cellar: :any,                 arm64_ventura: "afd2fa2143d779b048bfe077d7b66e6e713c13e3f631d35dbc21b0aff8544a51"
    sha256 cellar: :any,                 sonoma:        "b1e44d7c6ea98939e7870aab2c54889360abb57ddf37dc171ea137328b0757ac"
    sha256 cellar: :any,                 ventura:       "b1e44d7c6ea98939e7870aab2c54889360abb57ddf37dc171ea137328b0757ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9732dd85f7da31634f81d9fa63cc2159536c55bb154fcf3dfef9463e2314f0e8"
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