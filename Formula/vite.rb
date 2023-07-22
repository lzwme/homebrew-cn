require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.4.6.tgz"
  sha256 "bba5178872036d54e446579b037a288601ee3e96edc6a9620e03bfc6d6ed55f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07b660f90b6b273ab516b224ed094b3938a99f21ff9ab7e6f5d22f28f1c0482c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07b660f90b6b273ab516b224ed094b3938a99f21ff9ab7e6f5d22f28f1c0482c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07b660f90b6b273ab516b224ed094b3938a99f21ff9ab7e6f5d22f28f1c0482c"
    sha256 cellar: :any_skip_relocation, ventura:        "3663f7b71673cf17e5ee5ae82d15edd142ea50e7fb02b5743807c3f96be3accb"
    sha256 cellar: :any_skip_relocation, monterey:       "3663f7b71673cf17e5ee5ae82d15edd142ea50e7fb02b5743807c3f96be3accb"
    sha256 cellar: :any_skip_relocation, big_sur:        "3663f7b71673cf17e5ee5ae82d15edd142ea50e7fb02b5743807c3f96be3accb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab9550ea0a43e373db6fe20d309326c3bfd660708c4459fe0a194bf03cd7d7a2"
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