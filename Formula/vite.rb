require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.4.2.tgz"
  sha256 "a48d80711d9e1bcbc32efef705fff6e8e8443e8ae5686c551270ecd8fe931dad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6412b4773399d2bcc6ba2b2f47cb49c44b769f5c1e617f6c3c6336c276de452"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6412b4773399d2bcc6ba2b2f47cb49c44b769f5c1e617f6c3c6336c276de452"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6412b4773399d2bcc6ba2b2f47cb49c44b769f5c1e617f6c3c6336c276de452"
    sha256 cellar: :any_skip_relocation, ventura:        "e1c06b1148ee44d6224d54a0ff9be09ca43c1657c2a648ab90f8e875d555e911"
    sha256 cellar: :any_skip_relocation, monterey:       "e1c06b1148ee44d6224d54a0ff9be09ca43c1657c2a648ab90f8e875d555e911"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1c06b1148ee44d6224d54a0ff9be09ca43c1657c2a648ab90f8e875d555e911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd4091298f6017bf2ae09c7c93b2af448ab17fce67da3ef03497668422fa7ef3"
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