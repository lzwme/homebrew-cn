class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.6.tgz"
  sha256 "2c6f190d75d36545b7e33e9a627d0b9c8dbcfef939feffc5175bb4da162b1171"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35b889bf94d6b5890df1cf725ca68ed65cf4bc04e7a234e2f2e5068f3c6ded3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57ac0ea1f48f6861022c6a5966dfaaa502b73cf897f13334e8100ce9b96e5316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57ac0ea1f48f6861022c6a5966dfaaa502b73cf897f13334e8100ce9b96e5316"
    sha256 cellar: :any_skip_relocation, sonoma:        "271a391b0ad49b6e9533a6bd947294c6d584c1d78c855bb7817f872351b652b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52c3b74968eca0c6608e0e2596a821c26ae0a40b94479d867116dc1089d52b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52c3b74968eca0c6608e0e2596a821c26ae0a40b94479d867116dc1089d52b76"
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