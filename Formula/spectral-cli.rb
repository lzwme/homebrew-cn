require "language/node"

class SpectralCli < Formula
  desc "JSON/YAML linter and support OpenAPI v3.1/v3.0/v2.0, and AsyncAPI v2.x"
  homepage "https://stoplight.io/open-source/spectral"
  url "https://registry.npmjs.org/@stoplight/spectral-cli/-/spectral-cli-6.10.0.tgz"
  sha256 "bf4495a456ef938d0f034fe7309bfae26644d3db4bc8ab64109ece3d0e54d6e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab2191095cc19f6fd310a8fe62abde27f01980f11af2eac66205da36a40b7891"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab2191095cc19f6fd310a8fe62abde27f01980f11af2eac66205da36a40b7891"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab2191095cc19f6fd310a8fe62abde27f01980f11af2eac66205da36a40b7891"
    sha256 cellar: :any_skip_relocation, ventura:        "2b8b3e7a88e53459c9f2070c99736953863329ca3822070f0961321e5d02eb6c"
    sha256 cellar: :any_skip_relocation, monterey:       "2b8b3e7a88e53459c9f2070c99736953863329ca3822070f0961321e5d02eb6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b8b3e7a88e53459c9f2070c99736953863329ca3822070f0961321e5d02eb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54c67a79547786a08799a2d5f6da1ac66bbe270b54832a129540f92bff6cb630"
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