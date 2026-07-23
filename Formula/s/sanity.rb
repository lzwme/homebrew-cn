class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.12.0.tgz"
  sha256 "94f175b444a91280a6207974a2fa71e2c8e1b023766f71b276b3802a23debaaf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "205c840fab3c1a2924456b09e35f7f3d53e433e266291c01348ea1244a2cc915"
    sha256 cellar: :any, arm64_sequoia: "205c840fab3c1a2924456b09e35f7f3d53e433e266291c01348ea1244a2cc915"
    sha256 cellar: :any, arm64_sonoma:  "205c840fab3c1a2924456b09e35f7f3d53e433e266291c01348ea1244a2cc915"
    sha256 cellar: :any, sonoma:        "c96192e17f580654f0d85c3ed768d42d3ae236e3a6464a4ec81b6e156cc3564f"
    sha256 cellar: :any, arm64_linux:   "6793477f7286ca746b0a08bf0cbdc73c4baa6804065a49a35b09db6c6dce84d7"
    sha256 cellar: :any, x86_64_linux:  "e0f25b4b119c05c107d21d06567628dffc47fcf5dfec4892446e5574645043f1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end