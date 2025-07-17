class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.2.4.tgz"
  sha256 "6d5e6faaa143cd9e817b9f18f7cc763b4a480bff4b885c1c1217bab1d55255ca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "715c9d0175fb25f55bfff2ba30664de976ad779fabc4f47ee044c6e7f0261be3"
    sha256 cellar: :any,                 arm64_sonoma:  "715c9d0175fb25f55bfff2ba30664de976ad779fabc4f47ee044c6e7f0261be3"
    sha256 cellar: :any,                 arm64_ventura: "715c9d0175fb25f55bfff2ba30664de976ad779fabc4f47ee044c6e7f0261be3"
    sha256 cellar: :any,                 sonoma:        "094099d33044461a936f0c0b3940f1ef86e18606da409390d5a6e09d6d177dfd"
    sha256 cellar: :any,                 ventura:       "094099d33044461a936f0c0b3940f1ef86e18606da409390d5a6e09d6d177dfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e21141d00e3b295c3716241b0ed0dbcbfcdb7e80804ec9d1816c3beab2214442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e31fe59d84fe7b7dc2501986af477fe2bdea8f9421f262a38669b95c4cac0e77"
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