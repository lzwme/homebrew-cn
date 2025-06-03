class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.19.tgz"
  sha256 "53baa387abe53bfa80fd875ceb2001372bdcd9f1278b2f5e266de22e5bab4286"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6415579cf1619ea9e77026019a9334d05c0d4796d0e68ba184efe6b35d67ad4d"
    sha256 cellar: :any,                 arm64_sonoma:  "6415579cf1619ea9e77026019a9334d05c0d4796d0e68ba184efe6b35d67ad4d"
    sha256 cellar: :any,                 arm64_ventura: "6415579cf1619ea9e77026019a9334d05c0d4796d0e68ba184efe6b35d67ad4d"
    sha256 cellar: :any,                 sonoma:        "4fe7a351f54a67c0187ba93c291425ecfbc58559928d6273903cbbe039b0093a"
    sha256 cellar: :any,                 ventura:       "4fe7a351f54a67c0187ba93c291425ecfbc58559928d6273903cbbe039b0093a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a769b3a1cb01c2e41d8eb6594514baadbee04d7da8fb6964e624f1ac18fce05a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff0925d59dacf14a40be9a3d3f3b3e3f22d66d713920f11baeb3f2cc00967a51"
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