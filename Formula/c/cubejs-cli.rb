class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.7.tgz"
  sha256 "0be6aa8bb722757d268d317afd3dd107a204445212771a6e470b23ea41157b28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9d608133de609e48610b2f1a3813fb2e92a28822ce31b0508e560a06d3799d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b53cb14d4ed49417e4561e62c32c8fccbab04798ba57bc086bacb9f64b3109b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b53cb14d4ed49417e4561e62c32c8fccbab04798ba57bc086bacb9f64b3109b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c823048af13f406617f142fb637c1651d4e828876fe0746d8923843c6178afcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "269fdf86d190c1a8166e0352409db5af41ff64b99258de5ca891f9858d29cfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "269fdf86d190c1a8166e0352409db5af41ff64b99258de5ca891f9858d29cfe0"
  end

  depends_on "node"
  uses_from_macos "zlib"

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