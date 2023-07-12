require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.4.3.tgz"
  sha256 "0e84aeba4cae26ec7ba87ed90e93670cdc1b62cb1580d656d986c8f3b6456c83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25614676b4759a43db02cbc431ea1e8c49ae6ac8fd6476606f79da1b4df31ab1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25614676b4759a43db02cbc431ea1e8c49ae6ac8fd6476606f79da1b4df31ab1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25614676b4759a43db02cbc431ea1e8c49ae6ac8fd6476606f79da1b4df31ab1"
    sha256 cellar: :any_skip_relocation, ventura:        "2bc743bef0fef587437c115af48f6e0501c6154f2a75a29779e472583cac0c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "2bc743bef0fef587437c115af48f6e0501c6154f2a75a29779e472583cac0c4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bc743bef0fef587437c115af48f6e0501c6154f2a75a29779e472583cac0c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5debec734925e51242e214035b31e11f00295f798e6caec011bd2764af3c6545"
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