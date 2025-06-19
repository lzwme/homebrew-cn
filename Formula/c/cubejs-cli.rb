class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.22.tgz"
  sha256 "19e8c2b6d56472baecc290a07ba067e803cd0778741bbfbea8ae545d713e2906"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78718bb296ee4fab83a7ca7ea361df4e1cb764cd584d615f5830679b2f273d1c"
    sha256 cellar: :any,                 arm64_sonoma:  "78718bb296ee4fab83a7ca7ea361df4e1cb764cd584d615f5830679b2f273d1c"
    sha256 cellar: :any,                 arm64_ventura: "78718bb296ee4fab83a7ca7ea361df4e1cb764cd584d615f5830679b2f273d1c"
    sha256 cellar: :any,                 sonoma:        "6902454b896ae752d242045c15b1b705075bc5e31d30bf65495e54c31e97b5a7"
    sha256 cellar: :any,                 ventura:       "6902454b896ae752d242045c15b1b705075bc5e31d30bf65495e54c31e97b5a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f61881beb4c0fef39cac82439b5da9b44b3107ca6d799fd2b0bdd59ef7c3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff8c8c503762abeefd50e3f44473144ff71f2d07fc6078f24c66526fb65ded81"
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