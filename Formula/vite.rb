require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.4.5.tgz"
  sha256 "d47882f4fdae6f7b1452f9bbba10d9f278ef9fcd9602e315e1f5e2f72e89e3e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8a25bf6ec1cb275268b58a8adff5fa4dc39b1a7ac0acacd9a3221f885bdfae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8a25bf6ec1cb275268b58a8adff5fa4dc39b1a7ac0acacd9a3221f885bdfae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8a25bf6ec1cb275268b58a8adff5fa4dc39b1a7ac0acacd9a3221f885bdfae2"
    sha256 cellar: :any_skip_relocation, ventura:        "93cbb6f4cad6a76e31de9cf92339e9849b7ec5ae0d5c86938f9bcbb5654b3626"
    sha256 cellar: :any_skip_relocation, monterey:       "93cbb6f4cad6a76e31de9cf92339e9849b7ec5ae0d5c86938f9bcbb5654b3626"
    sha256 cellar: :any_skip_relocation, big_sur:        "93cbb6f4cad6a76e31de9cf92339e9849b7ec5ae0d5c86938f9bcbb5654b3626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46076cec5b7d6f7ccc57708f715cff1e6f01297a7022955fd8650216c00ea1df"
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