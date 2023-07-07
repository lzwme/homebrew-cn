require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.4.1.tgz"
  sha256 "57d4c9d1f4eec71b322bee8fb8dd452c882fe500d13e8490cf220b8e014a72b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa52685a7f6b3072872ceaf513955b8027043681a9ed18de1c5e7a6d6877e949"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa52685a7f6b3072872ceaf513955b8027043681a9ed18de1c5e7a6d6877e949"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa52685a7f6b3072872ceaf513955b8027043681a9ed18de1c5e7a6d6877e949"
    sha256 cellar: :any_skip_relocation, ventura:        "55cac1cc7416b6d073c86e8260e854f372d1d660a309a32e0ebb4e2ccf972f63"
    sha256 cellar: :any_skip_relocation, monterey:       "55cac1cc7416b6d073c86e8260e854f372d1d660a309a32e0ebb4e2ccf972f63"
    sha256 cellar: :any_skip_relocation, big_sur:        "55cac1cc7416b6d073c86e8260e854f372d1d660a309a32e0ebb4e2ccf972f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34dbb456df4a189f0afc283d9a3cee2a17dc47937e6a0ad939df34dd9b009ef0"
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