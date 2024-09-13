class SpectralCli < Formula
  desc "JSONYAML linter and support OpenAPI v3.1v3.0v2.0, and AsyncAPI v2.x"
  homepage "https:stoplight.ioopen-sourcespectral"
  url "https:registry.npmjs.org@stoplightspectral-cli-spectral-cli-6.12.0.tgz"
  sha256 "287fffa1f1a9fe565ab8fad1dfd9b201778db7685bdc36f5ab0ef7d21565ad58"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f04a79ba5915612e3fddff5396b02f02669b80f657403c5da5a03abaa80c667e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f04a79ba5915612e3fddff5396b02f02669b80f657403c5da5a03abaa80c667e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f04a79ba5915612e3fddff5396b02f02669b80f657403c5da5a03abaa80c667e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f04a79ba5915612e3fddff5396b02f02669b80f657403c5da5a03abaa80c667e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e93cbe50bd8a073826b62959be9f3cb87a2042f852981483f939d9fdf3b6901"
    sha256 cellar: :any_skip_relocation, ventura:        "0e93cbe50bd8a073826b62959be9f3cb87a2042f852981483f939d9fdf3b6901"
    sha256 cellar: :any_skip_relocation, monterey:       "0e93cbe50bd8a073826b62959be9f3cb87a2042f852981483f939d9fdf3b6901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f04a79ba5915612e3fddff5396b02f02669b80f657403c5da5a03abaa80c667e"
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