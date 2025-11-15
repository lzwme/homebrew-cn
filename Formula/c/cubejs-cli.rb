class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.3.tgz"
  sha256 "ec5771249f355755dff2eaaa39d43bac483e845031a0cda47e0ec381af1e4eeb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df7bec2f0fcf1401fd5d8bf0fe8a4bcdb956d59e450bf6bd9ddae4365f4cfb1c"
    sha256 cellar: :any,                 arm64_sequoia: "49637a254bcc571e8ba6fec39f203fcb68ef18213c3698e20b1d1df07ec2b16a"
    sha256 cellar: :any,                 arm64_sonoma:  "49637a254bcc571e8ba6fec39f203fcb68ef18213c3698e20b1d1df07ec2b16a"
    sha256 cellar: :any,                 sonoma:        "747c0f80e702b56bb0e2ac162c382ce342cbd72a0215f65bac3d6df1d4cea0ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5422f784d200a20d04e7826197b5565c3d13693c327d766a85d67bf32c9ed58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba0a4c279e98493cc8dd228c6c1d7bdcd0b6e2cc0a397c553970fded79b83200"
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