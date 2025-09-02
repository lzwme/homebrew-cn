class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.4.tgz"
  sha256 "bc0222c8a2d1b94fab6465d609c8d7fb0484c21facd280ef88ab1fdc99068475"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a638dc5b05a81b7742d5f37e70a866f55b4d23aa8eb18c41da6c3565073e86f7"
    sha256 cellar: :any,                 arm64_sonoma:  "a638dc5b05a81b7742d5f37e70a866f55b4d23aa8eb18c41da6c3565073e86f7"
    sha256 cellar: :any,                 arm64_ventura: "a638dc5b05a81b7742d5f37e70a866f55b4d23aa8eb18c41da6c3565073e86f7"
    sha256 cellar: :any,                 sonoma:        "18936cbf9952182c4b7b1c32b7ffc88946271859efd672754baf9e0d690c6365"
    sha256 cellar: :any,                 ventura:       "18936cbf9952182c4b7b1c32b7ffc88946271859efd672754baf9e0d690c6365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "053e941b85066c42f7d22d7c4f13d96cb76f8cbc4bce7e41fdc997157b337a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e2c5c31340dc8f00eb282d51de423e890b487635b6b06a80e8f8464246e71cb"
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