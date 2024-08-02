class SpectralCli < Formula
  desc "JSONYAML linter and support OpenAPI v3.1v3.0v2.0, and AsyncAPI v2.x"
  homepage "https:stoplight.ioopen-sourcespectral"
  url "https:registry.npmjs.org@stoplightspectral-cli-spectral-cli-6.11.1.tgz"
  sha256 "def3583f144cb7ba6d03d6814167ab3d6a8a27fff7f575b2c2ec72f0b133cc0e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2379f68ab9b0579b2c12a53615ab57cdc0b0e67d4e2217639db8bfb79db86f85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2379f68ab9b0579b2c12a53615ab57cdc0b0e67d4e2217639db8bfb79db86f85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2379f68ab9b0579b2c12a53615ab57cdc0b0e67d4e2217639db8bfb79db86f85"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f053496819d743631ea9c148461a7893d739c53c5230a42e01adc2f78178596"
    sha256 cellar: :any_skip_relocation, ventura:        "3f053496819d743631ea9c148461a7893d739c53c5230a42e01adc2f78178596"
    sha256 cellar: :any_skip_relocation, monterey:       "3f053496819d743631ea9c148461a7893d739c53c5230a42e01adc2f78178596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf2121c4406a8558364f34a6b9ee383df6414ebf8b933188b5920b030b24e684"
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
    assert_match "6 problems (0 errors, 6 warnings, 0 infos, 0 hints)", output

    assert_match version.to_s, shell_output("#{bin}spectral --version")
  end
end