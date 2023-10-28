require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.4.2.tgz"
  sha256 "dcdfc090f86271a1ec5f960a75ba041110f11c0b4722acf65a20b3e56d635a89"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "08ffe686b761f21f698f0e1b2feaf808ad725e2ff5722c8332154ad2ad0d4195"
    sha256                               arm64_ventura:  "5ff0a64a951de7e54f7700fa094359115944f61c211fba0dc820e94afc5f25ac"
    sha256                               arm64_monterey: "e002fb7b7c14687c0244a460a998b92b9ace87c108a435123b3750e28d5b587e"
    sha256                               sonoma:         "790a3f01585c6fe7441e3fb62c21694f165bc1735bb0bb19effe0b8a4284021d"
    sha256                               ventura:        "c501819731a785fcb5a3a0d1194dfc8dfc08a3ed97a27a7e09ccf69616789920"
    sha256                               monterey:       "e3ced4c35dddb1b9a85705e62c27803021239aa4791329cb9200af0ba0da8485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24716597ee8b095811598d0701850038fbe897dedbb745c33478124922224272"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@parcel/watcher/prebuilds/linux-x64/node.napi.musl.node").unlink
    (node_modules/"@nx/nx-linux-x64-musl/nx.linux-x64-musl.node").unlink if OS.linux?
    (node_modules/"@parcel/watcher/prebuilds").each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end