class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.15.1.tgz"
  sha256 "a6e2f8d5706d6ed10489a52cd4efa0bce5c84affb7302fd385dc42d72540df97"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3cb71e62fdf4ecbe1c6a1b1034b870ac6e6c391b03a45279dd97f8e30fec4e23"
    sha256 cellar: :any, arm64_sequoia: "3cb71e62fdf4ecbe1c6a1b1034b870ac6e6c391b03a45279dd97f8e30fec4e23"
    sha256 cellar: :any, arm64_sonoma:  "3cb71e62fdf4ecbe1c6a1b1034b870ac6e6c391b03a45279dd97f8e30fec4e23"
    sha256 cellar: :any, sonoma:        "b4b6cfebc4a6d7f77fea604c0ece7678d98ca18604af9da1e2148b6b6c822231"
    sha256 cellar: :any, arm64_linux:   "b55c22225dad1167e243201df3ec9435540d50feb34a597b559b6250f47b8f3e"
    sha256 cellar: :any, x86_64_linux:  "923e17d2eaf94e5382a057a475edaabd162eb48040570338e19e25b48321a1c8"
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