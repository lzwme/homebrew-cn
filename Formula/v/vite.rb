class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.2.tgz"
  sha256 "12ec31ea29c955fc40fbed27f5918302af1e402c1fb2ca8c4c22f4c028210f9a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6605c53c20eb9c138b99c92b1f937a99f1d3bc69d216eccd6dac73a50790fbce"
    sha256 cellar: :any,                 arm64_sonoma:  "6605c53c20eb9c138b99c92b1f937a99f1d3bc69d216eccd6dac73a50790fbce"
    sha256 cellar: :any,                 arm64_ventura: "6605c53c20eb9c138b99c92b1f937a99f1d3bc69d216eccd6dac73a50790fbce"
    sha256 cellar: :any,                 sonoma:        "d067ff8b6c9a112826985b636841d2f9490b662d925a44761b8bd852d6ed668c"
    sha256 cellar: :any,                 ventura:       "d067ff8b6c9a112826985b636841d2f9490b662d925a44761b8bd852d6ed668c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "688fbcabbc3f15b96d4f3eaf6b3762aea45e2deca0ce551e6d7145c14b1fba9f"
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