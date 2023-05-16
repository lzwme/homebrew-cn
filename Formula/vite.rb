require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.3.6.tgz"
  sha256 "a71b1eb2a56699fcc5bcc87fc8b2411d7b95fe64e7e1995bf8ab1fdc34f55f8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77d4f3d7891b28bc89cb35c3d5d926bbde86ff62d51c59d12d9114c617d181a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77d4f3d7891b28bc89cb35c3d5d926bbde86ff62d51c59d12d9114c617d181a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77d4f3d7891b28bc89cb35c3d5d926bbde86ff62d51c59d12d9114c617d181a4"
    sha256 cellar: :any_skip_relocation, ventura:        "d1b1bc4be0a75c271dbd1873ce1324d521f8d8705876fef9e8f8fa26fb95fc0c"
    sha256 cellar: :any_skip_relocation, monterey:       "d1b1bc4be0a75c271dbd1873ce1324d521f8d8705876fef9e8f8fa26fb95fc0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1b1bc4be0a75c271dbd1873ce1324d521f8d8705876fef9e8f8fa26fb95fc0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e2f1170d2b409a6a628ca459323772e41c0b77326b874e7cf88b3f20bcf09f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      system bin/"vite", "preview", "--port", port
    end
    sleep 2
    assert_match "Cannot GET /", shell_output("curl -s localhost:#{port}")
  end
end