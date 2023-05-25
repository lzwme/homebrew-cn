require "language/node"

class SpectralCli < Formula
  desc "JSON/YAML linter and support OpenAPI v3.1/v3.0/v2.0, and AsyncAPI v2.x"
  homepage "https://stoplight.io/open-source/spectral"
  url "https://registry.npmjs.org/@stoplight/spectral-cli/-/spectral-cli-6.8.0.tgz"
  sha256 "f06a4497b9e7a142f587e1da095857937929e72f602be66ec3d3947a0f254237"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "738477e11c7d3c550dafe59db021cd3b8853a1256af12ec1dbcc8e63c53ccbda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "738477e11c7d3c550dafe59db021cd3b8853a1256af12ec1dbcc8e63c53ccbda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "738477e11c7d3c550dafe59db021cd3b8853a1256af12ec1dbcc8e63c53ccbda"
    sha256 cellar: :any_skip_relocation, ventura:        "dc38f8556133e756a104594e3f9e167eedf4a70097a8a7eaa5936de1d0229426"
    sha256 cellar: :any_skip_relocation, monterey:       "dc38f8556133e756a104594e3f9e167eedf4a70097a8a7eaa5936de1d0229426"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc38f8556133e756a104594e3f9e167eedf4a70097a8a7eaa5936de1d0229426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "811894897aad9f4d2f7ccbd47c53e26df4a36217501f562138dc8ee53792fba9"
  end

  depends_on "node"

  resource "homebrew-petstore.yaml" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/OAI/OpenAPI-Specification/b12acf0c/examples/v3.0/petstore.yaml"
    sha256 "7dc119919441597e2b24335d8c8f6d01f1f0b895637f79b35e3863a3c2df9ddf"
  end

  resource "homebrew-streetlights-mqtt.yml" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/asyncapi/spec/1824379b/examples/streetlights-mqtt.yml"
    sha256 "7e17c9b465437a5a12decd93be49e37ca7ecfc48ff6f10e830d8290e9865d3af"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/@stoplight/spectral-cli/node_modules/fsevents/fsevents.node"
  end

  test do
    test_config = testpath/".spectral.yaml"
    test_config.write "extends: [\"spectral:oas\", \"spectral:asyncapi\"]"

    testpath.install resource("homebrew-petstore.yaml")
    output = shell_output("#{bin}/spectral lint -r #{test_config} #{testpath}/petstore.yaml")
    assert_match "8 problems (0 errors, 8 warnings, 0 infos, 0 hints)", output

    testpath.install resource("homebrew-streetlights-mqtt.yml")
    output = shell_output("#{bin}/spectral lint -r #{test_config} #{testpath}/streetlights-mqtt.yml")
    assert_match "6 problems (0 errors, 6 warnings, 0 infos, 0 hints)", output

    assert_match version.to_s, shell_output("#{bin}/spectral --version")
  end
end