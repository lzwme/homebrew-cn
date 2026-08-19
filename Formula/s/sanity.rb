class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.0.1.tgz"
  sha256 "09221a399038d803c44703fa9a918e548ec270e93ceec340d55fb0b685a1c2f1"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b0b9bae2aa44e2016c539dfc1e8fa4079759ab87961474a37337376a8279713d"
    sha256 cellar: :any, arm64_sequoia: "b0b9bae2aa44e2016c539dfc1e8fa4079759ab87961474a37337376a8279713d"
    sha256 cellar: :any, arm64_sonoma:  "b0b9bae2aa44e2016c539dfc1e8fa4079759ab87961474a37337376a8279713d"
    sha256 cellar: :any, sonoma:        "a558c752ace3de86e971780d2ad5b985d314ad296ab843e6ea6107275d76ff79"
    sha256 cellar: :any, arm64_linux:   "abf58582457f10417724269755f73ff07c88da7179e773047f3f4eaa2f11232a"
    sha256 cellar: :any, x86_64_linux:  "bafd71d2fc4aa120da348d61c340f35b933c237e492cc6d7d08104ca99e3a03d"
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