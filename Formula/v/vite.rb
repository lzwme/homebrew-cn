class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.0.tgz"
  sha256 "1526b449c150f5347d24b53c22a39d4f91e3a4fa684ab37ec0ab0134e36c5757"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5eebd28103dd47cc42e0902a6504c73a0bbb6af26e5ca4ecb6bf4f32c3ab5fc"
    sha256 cellar: :any,                 arm64_sonoma:  "a5eebd28103dd47cc42e0902a6504c73a0bbb6af26e5ca4ecb6bf4f32c3ab5fc"
    sha256 cellar: :any,                 arm64_ventura: "a5eebd28103dd47cc42e0902a6504c73a0bbb6af26e5ca4ecb6bf4f32c3ab5fc"
    sha256 cellar: :any,                 sonoma:        "cb1896a051e40f935d6ea9d132ce8f7d536c0d280615f1811e7d2637264a4c32"
    sha256 cellar: :any,                 ventura:       "cb1896a051e40f935d6ea9d132ce8f7d536c0d280615f1811e7d2637264a4c32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c2785db4db3a507b14840ef270625085fe6bcab64859e84585e5aee0dfa13cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6aaf7c032e8cd09c7baf6b9a14e39d868c5de803906d4f72762a5a1e4e3834b"
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