require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.4.1.tgz"
  sha256 "6acd0680b161e6cdad1fca70225d6d30095677d8002ea0972aa65c68d287caef"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "ef7ce5d3fe57eb5481d8c8df8d41c8589e518effc40ffe1445cb1ea12d74b516"
    sha256                               arm64_ventura:  "e747b609c5ce5c20d3f00b2255cf9728f68420edeb4f0d7b95fe0c7bb7fc7acc"
    sha256                               arm64_monterey: "4d2d5ebad103b1d23049752c660573d0b6ea85b72ee602d1d7d4f5a2d19a59a4"
    sha256                               sonoma:         "e1b3a1ca4e7998dbbd4af416b9d5780776f0d28364659b3b61fe9bd551e5a143"
    sha256                               ventura:        "8be857c3099570eff7fc645b9de8a301cdd7722752cd14bfa6a23acbdb33bd23"
    sha256                               monterey:       "1e38e8f935a6fe4c09aa5dfb3e22d4e2a5cb747b1d885723b887336268a6d165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb9fc9e36128912a746199564e4f0a897c06434a6be6fd198c642675aee0fb0b"
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