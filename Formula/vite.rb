require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.4.4.tgz"
  sha256 "97d8b956d0978350137e0a4f7491b668529403c0a379e5a75b73cdfedb1ebb80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42342c1d8d2031312d547ce90edabea609f00e3e446ac612f4e948efba6ddb78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42342c1d8d2031312d547ce90edabea609f00e3e446ac612f4e948efba6ddb78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42342c1d8d2031312d547ce90edabea609f00e3e446ac612f4e948efba6ddb78"
    sha256 cellar: :any_skip_relocation, ventura:        "58285056b09c188a8c656e7cd192e937b47a89ca900d89f7894f35e2d95c1055"
    sha256 cellar: :any_skip_relocation, monterey:       "58285056b09c188a8c656e7cd192e937b47a89ca900d89f7894f35e2d95c1055"
    sha256 cellar: :any_skip_relocation, big_sur:        "58285056b09c188a8c656e7cd192e937b47a89ca900d89f7894f35e2d95c1055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3374f4562611bb61aa50579db31a4ee341ce505ab083c864e526675c9d4c7709"
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