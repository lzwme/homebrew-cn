class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.13.tgz"
  sha256 "0b5c8e931ab441834016cc5b52984ae48aeda36f9b44c94009d2feb9d091f5a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64c7214c39baf71f49dc57417b5c358772331b3a6f79626859a4b05d12739f04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64c7214c39baf71f49dc57417b5c358772331b3a6f79626859a4b05d12739f04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64c7214c39baf71f49dc57417b5c358772331b3a6f79626859a4b05d12739f04"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fa3c06dd5ae35f2db59835be819130bb50944d80fab799c6d77718bdd89e8b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f143e25f63a1882f88127aacb8dd365ce438f97086d12f7a2c28f2866c94b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f143e25f63a1882f88127aacb8dd365ce438f97086d12f7a2c28f2866c94b13"
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