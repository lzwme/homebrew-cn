class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/sanity/-/sanity-5.28.0.tgz"
  sha256 "22a2dd8c7a8fddf928e0f2239ff83c885b454e2bdf89e5797e37c9b6295682cc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bbfea60ca1ee995e36f6c0197afae16ff0973679526a5a1c86e2a026b764005e"
    sha256 cellar: :any, arm64_sequoia: "71ba3fa94fd86e5d1e63e6c680789f9537823230114e9713d41d4356c196c055"
    sha256 cellar: :any, arm64_sonoma:  "71ba3fa94fd86e5d1e63e6c680789f9537823230114e9713d41d4356c196c055"
    sha256 cellar: :any, sonoma:        "b574a33bcf1da749888b20dee59b583f3141f2479f1781ec14a678433d48c46c"
    sha256 cellar: :any, arm64_linux:   "0f3a7092ae142a7adee291bc2715d700ffa582cc75c16f66582528d1e7bd3143"
    sha256 cellar: :any, x86_64_linux:  "148c06d825eb4d01f87a85236cb4881fa144cc147c88eec3028741c620be5aa8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/sanity/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
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