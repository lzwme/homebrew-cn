class SpectralCli < Formula
  desc "JSONYAML linter and support OpenAPI v3.1v3.0v2.0, and AsyncAPI v2.x"
  homepage "https:stoplight.ioopen-sourcespectral"
  url "https:registry.npmjs.org@stoplightspectral-cli-spectral-cli-6.15.0.tgz"
  sha256 "d4e7bd215586ba1619bb495b6d7ecc336431eab9ab0214f0b16ab56a9c145072"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0386c9607a723c93d0811eb9876eb84466667f7ad7b2c93ac1c48f2909a5b26c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0386c9607a723c93d0811eb9876eb84466667f7ad7b2c93ac1c48f2909a5b26c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0386c9607a723c93d0811eb9876eb84466667f7ad7b2c93ac1c48f2909a5b26c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a980039a70ffc224d6285ffe72f96a8253f68c8cb625f79199f6d3c49979946"
    sha256 cellar: :any_skip_relocation, ventura:       "6a980039a70ffc224d6285ffe72f96a8253f68c8cb625f79199f6d3c49979946"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0386c9607a723c93d0811eb9876eb84466667f7ad7b2c93ac1c48f2909a5b26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0386c9607a723c93d0811eb9876eb84466667f7ad7b2c93ac1c48f2909a5b26c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    resource "homebrew-petstore.yaml" do
      url "https:raw.githubusercontent.comOAIOpenAPI-Specificationb12acf0cexamplesv3.0petstore.yaml"
      sha256 "7dc119919441597e2b24335d8c8f6d01f1f0b895637f79b35e3863a3c2df9ddf"
    end

    resource "homebrew-streetlights-mqtt.yml" do
      url "https:raw.githubusercontent.comasyncapispec1824379bexamplesstreetlights-mqtt.yml"
      sha256 "7e17c9b465437a5a12decd93be49e37ca7ecfc48ff6f10e830d8290e9865d3af"
    end

    test_config = testpath".spectral.yaml"
    test_config.write "extends: [\"spectral:oas\", \"spectral:asyncapi\"]"

    testpath.install resource("homebrew-petstore.yaml")
    output = shell_output("#{bin}spectral lint -r #{test_config} #{testpath}petstore.yaml")
    assert_match "8 problems (0 errors, 8 warnings, 0 infos, 0 hints)", output

    testpath.install resource("homebrew-streetlights-mqtt.yml")
    output = shell_output("#{bin}spectral lint -r #{test_config} #{testpath}streetlights-mqtt.yml")
    assert_match "7 problems (0 errors, 6 warnings, 1 info, 0 hints)", output

    assert_match version.to_s, shell_output("#{bin}spectral --version")
  end
end