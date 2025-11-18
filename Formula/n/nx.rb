class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.0.4.tgz"
  sha256 "79c117644cc82d0e1b696f5eaa65d0c2dbc038d666dd34c67efb5d1fe8ab3c7e"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2ea58da010e034d80802a04e592cc3b76862217e41a20ea987ebde0172c5a14"
    sha256 cellar: :any,                 arm64_sequoia: "74e3c1815e1ad8f843de737a717735f4493e7d9de1a8cc27e8adcec47dbf3837"
    sha256 cellar: :any,                 arm64_sonoma:  "74e3c1815e1ad8f843de737a717735f4493e7d9de1a8cc27e8adcec47dbf3837"
    sha256 cellar: :any,                 sonoma:        "cbc5ef64df2a11622aa789a828782c7b2c01fe4e4a5eb684f3e05fc8e4f60f02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9bc2756e841e72f6fd8264da30429ad07ea69b48e9a65ea2460b44294fd9f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "981581b8c8f273c9c7a7fae60aba49866dcbd65253ed7f37606ca907d520e591"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end