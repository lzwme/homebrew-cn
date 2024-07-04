require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.3.3.tgz"
  sha256 "5aab2b347a45a553c73008ff7986c538af1432090199074923934daaa6b8327e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "40234e4ee91de1640d858fa61c5e464eb7fe3bf07dcdb226c43e393d5a9a306a"
    sha256 cellar: :any,                 arm64_ventura:  "40234e4ee91de1640d858fa61c5e464eb7fe3bf07dcdb226c43e393d5a9a306a"
    sha256 cellar: :any,                 arm64_monterey: "40234e4ee91de1640d858fa61c5e464eb7fe3bf07dcdb226c43e393d5a9a306a"
    sha256 cellar: :any,                 sonoma:         "5e7cba58028b607a35a30ae506e48bd1b0c9639f12051494b34d4daf6e16892a"
    sha256 cellar: :any,                 ventura:        "5e7cba58028b607a35a30ae506e48bd1b0c9639f12051494b34d4daf6e16892a"
    sha256 cellar: :any,                 monterey:       "5e7cba58028b607a35a30ae506e48bd1b0c9639f12051494b34d4daf6e16892a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e522711a02d6a163e5062421eea7a5775bedcb49d3542d762216291a5f21e42f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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