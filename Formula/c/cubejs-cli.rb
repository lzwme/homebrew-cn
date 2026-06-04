class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.53.tgz"
  sha256 "216d9b1ad8633121b5dcc32d33835b0cab48b037c35e777948b5b5d5b5c89a46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d44971ea4969929b8c33f2a33c1ca38ee5f1613dc36d79dae675beb5b91d6f23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "346ee067fe04a1b19ccf7b2c434f7c0a280656fb408a8278f8584900e98cc9d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "346ee067fe04a1b19ccf7b2c434f7c0a280656fb408a8278f8584900e98cc9d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c8f6377e45d63290a4a7b960d90cff916e609be6d36fce16ca15daae4c69112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f28ffa455357ba1267057753557c87d824fbdbc6517208b0c960425799543919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f28ffa455357ba1267057753557c87d824fbdbc6517208b0c960425799543919"
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