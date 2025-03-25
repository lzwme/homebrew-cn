class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.2.3.tgz"
  sha256 "b51cd078d530024b4ca5f19a2b786c95b8a21ec20dfc98dae67e17e8070477f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9193837c374b51c81e3692d4cbfc5b899ac96864f60924d436f75b53a0424009"
    sha256 cellar: :any,                 arm64_sonoma:  "9193837c374b51c81e3692d4cbfc5b899ac96864f60924d436f75b53a0424009"
    sha256 cellar: :any,                 arm64_ventura: "9193837c374b51c81e3692d4cbfc5b899ac96864f60924d436f75b53a0424009"
    sha256 cellar: :any,                 sonoma:        "e5c96730023d51e57b9fe6c9d0acba1a3312c4d4e5a9402ff004dc58d307800d"
    sha256 cellar: :any,                 ventura:       "e5c96730023d51e57b9fe6c9d0acba1a3312c4d4e5a9402ff004dc58d307800d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09b3ddbc5a786d3f0942ab1979bd52e08d8516ef634ec62efa26cf4ff03ad528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f1471f8dc2f28fe1689ee2b1d242b56fe2b969defaa9d5644316097d9eb07b7"
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