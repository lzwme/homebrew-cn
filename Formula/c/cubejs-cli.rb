class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.12.tgz"
  sha256 "36220715aa8ad7ecddcc19c12362341f4158be5390b5ee6981200f8e6d6e6142"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1351eeddefc49c51def4ebc5d1aaa2d208114d052e0965b5ffbbc11fc0d3c43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91aa54e7f53473719ced5060db999e01522abcd822c240996a61d91b92ada92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91aa54e7f53473719ced5060db999e01522abcd822c240996a61d91b92ada92"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d9f686f7a66bd987f0d65585b527ab7bdeba8025994a498b4cff514afc7a29b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0de5b9648ea6f46d66572b4471d6e288a0aad91a3e7ad1e4330fd0024f9d154d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de5b9648ea6f46d66572b4471d6e288a0aad91a3e7ad1e4330fd0024f9d154d"
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