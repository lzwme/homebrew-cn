require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.4.10.tgz"
  sha256 "3e3bddb904aeff953d4028f08b37234ff4d6ee6c9492a4e76beb3bea6b43524e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f11d71f358cc56d02b1e3beb5403d9ebf1f05ca65da05f5e788b048e4c3c6a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f11d71f358cc56d02b1e3beb5403d9ebf1f05ca65da05f5e788b048e4c3c6a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f11d71f358cc56d02b1e3beb5403d9ebf1f05ca65da05f5e788b048e4c3c6a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b637492c6a0bbd29710f3b8e79b0a535e92ed0cf9c6bbda0a492cd94860563aa"
    sha256 cellar: :any_skip_relocation, ventura:        "b637492c6a0bbd29710f3b8e79b0a535e92ed0cf9c6bbda0a492cd94860563aa"
    sha256 cellar: :any_skip_relocation, monterey:       "b637492c6a0bbd29710f3b8e79b0a535e92ed0cf9c6bbda0a492cd94860563aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc52df6d1f6e7d5ea7f887a4b00c66ddb30d1cfce9dc4c5e5e40bc85028c290"
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