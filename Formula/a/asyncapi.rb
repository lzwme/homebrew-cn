require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.13.tgz"
  sha256 "d31435266b1378e9161c0c47669a490f08b0123cf3d1a04e928f564de7bb620c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "08fcedaff1d0f6ad8b071e033e607d4d0ac9207900fcaed98b0aff5110fa2397"
    sha256 cellar: :any,                 arm64_ventura:  "08fcedaff1d0f6ad8b071e033e607d4d0ac9207900fcaed98b0aff5110fa2397"
    sha256 cellar: :any,                 arm64_monterey: "08fcedaff1d0f6ad8b071e033e607d4d0ac9207900fcaed98b0aff5110fa2397"
    sha256 cellar: :any,                 sonoma:         "1b22840a8c5471d813a5a38b2e3fc68661b8d69a7cdf42110d55d7e9e0714116"
    sha256 cellar: :any,                 ventura:        "1b22840a8c5471d813a5a38b2e3fc68661b8d69a7cdf42110d55d7e9e0714116"
    sha256 cellar: :any,                 monterey:       "1b22840a8c5471d813a5a38b2e3fc68661b8d69a7cdf42110d55d7e9e0714116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dfe06981932b0e29a2a1c505c40fdbcfc1eedb7d66c60fea2707000a2dbabcc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end