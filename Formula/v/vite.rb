class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.7.tgz"
  sha256 "2a4842c2ff6e683a4ab3171c318a9054b1ac986be8ae5b043d20afb54a0ec319"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a401a7a8935dfd7dc6cfe7e8dffbd569b6c1a914325ae022c3ef0400e34fc742"
    sha256 cellar: :any,                 arm64_sonoma:  "a401a7a8935dfd7dc6cfe7e8dffbd569b6c1a914325ae022c3ef0400e34fc742"
    sha256 cellar: :any,                 arm64_ventura: "a401a7a8935dfd7dc6cfe7e8dffbd569b6c1a914325ae022c3ef0400e34fc742"
    sha256 cellar: :any,                 sonoma:        "67fbc4d365ac575b6e518293aa1d39307478bef3e6ab831b559c6d948fb16413"
    sha256 cellar: :any,                 ventura:       "67fbc4d365ac575b6e518293aa1d39307478bef3e6ab831b559c6d948fb16413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067d6071854892e4df811d3f78df22dbe0e5d78d835f7b7e712f70bcdf161600"
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