class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.7.tgz"
  sha256 "909677001b9a85299e620c9911b4010197753be9431a96f4ae4dea916e018ba5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "919d0f76dd3ea4241add0072b489a88f8ebc1ba85c4f7343341cbfa9bc7a2516"
    sha256 cellar: :any,                 arm64_sonoma:  "919d0f76dd3ea4241add0072b489a88f8ebc1ba85c4f7343341cbfa9bc7a2516"
    sha256 cellar: :any,                 arm64_ventura: "919d0f76dd3ea4241add0072b489a88f8ebc1ba85c4f7343341cbfa9bc7a2516"
    sha256 cellar: :any,                 sonoma:        "b64e68193e349da25f23ab86c35496bd14f07cada8cf783aaa22ef033ce66d8f"
    sha256 cellar: :any,                 ventura:       "b64e68193e349da25f23ab86c35496bd14f07cada8cf783aaa22ef033ce66d8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "550a4569f868f3f5b6256a3e76e83d7f0bb7a5eee100f1a8c6437edac769ccaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6394f9efde8e7272b3094318a17fc6ba371d06bced921736035836717ad14928"
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