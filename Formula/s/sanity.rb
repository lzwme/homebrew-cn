class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.13.0.tgz"
  sha256 "cfa24ff642469eabe02fc5cfc954dada5b2ade7dca3b6daf5e333aa01acc4c43"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c0ec10a41ffce76d9519b3ca97d4a5913214bdd2795df2d17b16d1ea1a096f34"
    sha256 cellar: :any, arm64_sequoia: "c0ec10a41ffce76d9519b3ca97d4a5913214bdd2795df2d17b16d1ea1a096f34"
    sha256 cellar: :any, arm64_sonoma:  "c0ec10a41ffce76d9519b3ca97d4a5913214bdd2795df2d17b16d1ea1a096f34"
    sha256 cellar: :any, sonoma:        "ab36b423b3cec490181588a02f36e39dccc7c8437d6d9e784309e949679ea0a3"
    sha256 cellar: :any, arm64_linux:   "9c9ad4118eed7f0b361e20ee0135dca822ae8c31c9561b488df64b1d5bd99369"
    sha256 cellar: :any, x86_64_linux:  "32eeb6f4bf3d33ac75b82bd6c92ef9c7da670b7772dd46979d4087d67373ea9c"
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