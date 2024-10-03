class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.5.tgz"
  sha256 "349f2373f0b26be80adff1b130cb2d3d3056663840e5b69993ffdb9e482b094e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69ecee34a6c7a20c378727c89efc5e0d6c62bbb01772ecfca999d6bdff95212c"
    sha256 cellar: :any,                 arm64_sonoma:  "69ecee34a6c7a20c378727c89efc5e0d6c62bbb01772ecfca999d6bdff95212c"
    sha256 cellar: :any,                 arm64_ventura: "69ecee34a6c7a20c378727c89efc5e0d6c62bbb01772ecfca999d6bdff95212c"
    sha256 cellar: :any,                 sonoma:        "98e25b0297a9a46746ee3f99ac486e938cf594d860d94ed89b8aec05912cf16b"
    sha256 cellar: :any,                 ventura:       "98e25b0297a9a46746ee3f99ac486e938cf594d860d94ed89b8aec05912cf16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "723330a7cd923e2ae84fc1acc390a5483937706b99746647a8015dc3274669aa"
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
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end