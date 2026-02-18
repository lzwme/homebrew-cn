class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.13.tgz"
  sha256 "3b2149a21272c78257f9197cf1af133118d3d495176996c27ee1030c7c64cb24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f5b69d9370583f8189fdfea3fde2d5f60e30ea4a77766713bc50093f49f333e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "158711f9096ce0125935fd90f6e16fdd3f7de22363b5c6382961f347c40dacb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "158711f9096ce0125935fd90f6e16fdd3f7de22363b5c6382961f347c40dacb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "15a29bea8f174d8dbd14e6ad2dda71eeeb8c864087aa55026e7c481ff433b42c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9495aa6431750a4c31bc06d0a64fe5f96b27c225777ae1b7affbaa602a536da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9495aa6431750a4c31bc06d0a64fe5f96b27c225777ae1b7affbaa602a536da"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end