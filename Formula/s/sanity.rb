class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.0.0.tgz"
  sha256 "3318a03f8067a0f43697fcafccbb05032cb5bf062b54a58bf4b9fc9304333c4b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "30ab976b8fd66e90982661586d3032666a1fff54a7d07a9aeb11eef4c6a9ad42"
    sha256 cellar: :any, arm64_sequoia: "30ab976b8fd66e90982661586d3032666a1fff54a7d07a9aeb11eef4c6a9ad42"
    sha256 cellar: :any, arm64_sonoma:  "30ab976b8fd66e90982661586d3032666a1fff54a7d07a9aeb11eef4c6a9ad42"
    sha256 cellar: :any, sonoma:        "c5f343f95dcb9ba92f724a8ded7b53a3ed702672a6b000c7c40095c9c583796d"
    sha256 cellar: :any, arm64_linux:   "cbcbc4780a2ac7d89434f9b57e385f0d9b2d501cce84a1c76e18f99e2c577d0d"
    sha256 cellar: :any, x86_64_linux:  "12436dff1a4a4b800914189bf36e0495edd745a83d245a04d934541065cd1504"
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