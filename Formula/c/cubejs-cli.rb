class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.55.tgz"
  sha256 "771dc9f1e2c1f3627ad310d52e6b819fc97c6a3ce127c426eb5c5005f9c868e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33035bd629306f460951bb50d84272c77c71cf59f9a43b45f4473d0d2de68e8c"
    sha256 cellar: :any,                 arm64_sonoma:  "33035bd629306f460951bb50d84272c77c71cf59f9a43b45f4473d0d2de68e8c"
    sha256 cellar: :any,                 arm64_ventura: "33035bd629306f460951bb50d84272c77c71cf59f9a43b45f4473d0d2de68e8c"
    sha256 cellar: :any,                 sonoma:        "d395743244505150f95a5faf30167991efe6d068eea0f168f15d89eb5352a414"
    sha256 cellar: :any,                 ventura:       "d395743244505150f95a5faf30167991efe6d068eea0f168f15d89eb5352a414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e28cf7bcaefeb237650fa4381365fc541a1108a2d5ff984516fc89c03169d578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd319b559576aa47dae52e09d578b59d4eaaf4f0292679de513fd06b994c8ac"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end