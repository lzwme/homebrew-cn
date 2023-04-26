require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.3.2.tgz"
  sha256 "5f776da23fbe24d4c9493e59b1ddaa3684cdd88c5a51d2715b5ece29d4e972f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "703db7cffae49ec996b5517234a049dcea1be3232338c7c9046c34f1fab73c32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "703db7cffae49ec996b5517234a049dcea1be3232338c7c9046c34f1fab73c32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "703db7cffae49ec996b5517234a049dcea1be3232338c7c9046c34f1fab73c32"
    sha256 cellar: :any_skip_relocation, ventura:        "f3e7a051a922c292e0c63777c7014ac5aa211603723cebd0a7deebdc33939d4d"
    sha256 cellar: :any_skip_relocation, monterey:       "f3e7a051a922c292e0c63777c7014ac5aa211603723cebd0a7deebdc33939d4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3e7a051a922c292e0c63777c7014ac5aa211603723cebd0a7deebdc33939d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0542b881fb358f80ffe77c05f591a042dd899878c286a74faf6c5402ad64b8"
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