require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.3.8.tgz"
  sha256 "47278434aa5d48ea3c187215ff8a116041739221831193a4a42ed138d764b4c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c425865931abd4f8acc89b004c00a831991c94a061eb569c3e02d670bfdae4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c425865931abd4f8acc89b004c00a831991c94a061eb569c3e02d670bfdae4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c425865931abd4f8acc89b004c00a831991c94a061eb569c3e02d670bfdae4b"
    sha256 cellar: :any_skip_relocation, ventura:        "0adea4dc988a6fd8160098d3e4d414e10f948b0c3794a1d9cb349a5bf282eb06"
    sha256 cellar: :any_skip_relocation, monterey:       "0adea4dc988a6fd8160098d3e4d414e10f948b0c3794a1d9cb349a5bf282eb06"
    sha256 cellar: :any_skip_relocation, big_sur:        "0adea4dc988a6fd8160098d3e4d414e10f948b0c3794a1d9cb349a5bf282eb06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3de5c1d1553870a037d5cd8125fe1d9ee7d1c967fd90de9218a3f0b1e1f2c58c"
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