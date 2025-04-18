class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.3.1.tgz"
  sha256 "309f0ba44d49c0177cbc2e5d05445759c2edb3520110c23a685bdb5c1a87bfb1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "079726bfd9c6dd1471a5d895c009bcbd73be05d3e500fc58da5efa434d5854c9"
    sha256 cellar: :any,                 arm64_sonoma:  "079726bfd9c6dd1471a5d895c009bcbd73be05d3e500fc58da5efa434d5854c9"
    sha256 cellar: :any,                 arm64_ventura: "079726bfd9c6dd1471a5d895c009bcbd73be05d3e500fc58da5efa434d5854c9"
    sha256 cellar: :any,                 sonoma:        "0205f54324f86991684a9f9c66c4458bc0addeb5ca643071b23f395f412cc6bf"
    sha256 cellar: :any,                 ventura:       "0205f54324f86991684a9f9c66c4458bc0addeb5ca643071b23f395f412cc6bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e8f61e7868f2a432cfacdd6ff63e35ae894420fa4a4f74654666429faad0202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "161995dff2f92cdf9f770e99fc0481c3d96b2229d3b0352def6e0102849f8eff"
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