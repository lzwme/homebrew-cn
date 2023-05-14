require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.6.tgz"
  sha256 "9efff07c240a63759d827386a1fd9da86a4d425002662e652347d5f90b4cdcf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2eab08d36e68ed2c297f418cffca62a56ad8218862f818c11d3d18dee872ed1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2eab08d36e68ed2c297f418cffca62a56ad8218862f818c11d3d18dee872ed1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2eab08d36e68ed2c297f418cffca62a56ad8218862f818c11d3d18dee872ed1"
    sha256 cellar: :any_skip_relocation, ventura:        "6458839feae7771d1227587d9cb13ad4060d0cd21b8c4bd87ec85316769e33a3"
    sha256 cellar: :any_skip_relocation, monterey:       "6458839feae7771d1227587d9cb13ad4060d0cd21b8c4bd87ec85316769e33a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6458839feae7771d1227587d9cb13ad4060d0cd21b8c4bd87ec85316769e33a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2eab08d36e68ed2c297f418cffca62a56ad8218862f818c11d3d18dee872ed1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end