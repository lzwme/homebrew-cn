require "language/node"

class SpectralCli < Formula
  desc "JSON/YAML linter and support OpenAPI v3.1/v3.0/v2.0, and AsyncAPI v2.x"
  homepage "https://stoplight.io/open-source/spectral"
  url "https://registry.npmjs.org/@stoplight/spectral-cli/-/spectral-cli-6.6.0.tgz"
  sha256 "be10eda3f272cd2cab3f6a43a24826b1c1f99ac22e46303695c88820ca5655f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8094984ad27a565eba603823f4ab1ad2b5c715b6779d00732ad8898000887f32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8094984ad27a565eba603823f4ab1ad2b5c715b6779d00732ad8898000887f32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8094984ad27a565eba603823f4ab1ad2b5c715b6779d00732ad8898000887f32"
    sha256 cellar: :any_skip_relocation, ventura:        "8fadf7da982609f149bf3ce4ab4d848c2631adfd6f49defd83f417cec3d7b93c"
    sha256 cellar: :any_skip_relocation, monterey:       "8fadf7da982609f149bf3ce4ab4d848c2631adfd6f49defd83f417cec3d7b93c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fadf7da982609f149bf3ce4ab4d848c2631adfd6f49defd83f417cec3d7b93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "475a7ec50de3503a4639f8dc7ff036cd79c171400a806cfe7b88dcaa2437b029"
  end

  depends_on "node"

  resource "homebrew-petstore.yaml" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/OAI/OpenAPI-Specification/b12acf0c/examples/v3.0/petstore.yaml"
    sha256 "7dc119919441597e2b24335d8c8f6d01f1f0b895637f79b35e3863a3c2df9ddf"
  end

  resource "homebrew-streetlights-mqtt.yml" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/asyncapi/spec/1e3ec47f/examples/streetlights-mqtt.yml"
    sha256 "e32f08644e3af724a9bc7ea622e6a6285a93dc4b8ee1be2b7c957c460a3182ba"
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