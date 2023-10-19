require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.5.0.tgz"
  sha256 "5341e86fd426dfcb0dda740c573a9fd0a22e2aeb364baa06ad5b715b5c5fc391"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfe193c6c09471959b2b8b8e9860c6e4f91bcacbea5134490eda7e48fe49afef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfe193c6c09471959b2b8b8e9860c6e4f91bcacbea5134490eda7e48fe49afef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfe193c6c09471959b2b8b8e9860c6e4f91bcacbea5134490eda7e48fe49afef"
    sha256 cellar: :any_skip_relocation, sonoma:         "9857afe30fb99aa77e2873c4cd0649820b4fc7ee94fba6a8081416df5e51a2b6"
    sha256 cellar: :any_skip_relocation, ventura:        "9857afe30fb99aa77e2873c4cd0649820b4fc7ee94fba6a8081416df5e51a2b6"
    sha256 cellar: :any_skip_relocation, monterey:       "9857afe30fb99aa77e2873c4cd0649820b4fc7ee94fba6a8081416df5e51a2b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e9a339af553788633b2b9ab57b9ad8784b3905d99e9b86a63c14123e1f7a1d"
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