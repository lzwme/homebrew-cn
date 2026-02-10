class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.10.tgz"
  sha256 "b81db7106937a26aecd1430a2bc33e2da152da60729b98b76bf8dce63c2a310c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be8facc77da0b03d5d4e020e75826bd14730362ca20854f6e53ba940978b6fad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bbe4523deb2bdc5382d2a50502bc98f601956f6d54ab6e6c4a522d31407b358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bbe4523deb2bdc5382d2a50502bc98f601956f6d54ab6e6c4a522d31407b358"
    sha256 cellar: :any_skip_relocation, sonoma:        "66f65729950b56ebaaf70a2c6dd92607e09ac223966e5a556c9d0fd7f6e38ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abe4bea7129516476f4b3efbd1381f635364e60f32406e62514498fee6b8fe1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abe4bea7129516476f4b3efbd1381f635364e60f32406e62514498fee6b8fe1b"
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