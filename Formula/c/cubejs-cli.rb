class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.37.tgz"
  sha256 "5de54935da8321aa23748a1da76ab43fd5dcd0d00633ab6fb5c697f8e65d638e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c2a42f70d04ee8ff9174876eb5641e689b6fc7a4f6fbd6a7e22cf97cd8f53f9b"
    sha256 cellar: :any,                 arm64_sonoma:  "c2a42f70d04ee8ff9174876eb5641e689b6fc7a4f6fbd6a7e22cf97cd8f53f9b"
    sha256 cellar: :any,                 arm64_ventura: "c2a42f70d04ee8ff9174876eb5641e689b6fc7a4f6fbd6a7e22cf97cd8f53f9b"
    sha256 cellar: :any,                 sonoma:        "b6db076c6792157eba3354dcd42f988adc003234c174d28ac4166697510f65ce"
    sha256 cellar: :any,                 ventura:       "b6db076c6792157eba3354dcd42f988adc003234c174d28ac4166697510f65ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f183e2a0d9b57716c8e4992f15dbc39a396d15d122bab3e7520af4edd9025c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "995d1ecde17cb739e51e638f8fc7415c062475767cc446f33e45b82216273eaa"
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