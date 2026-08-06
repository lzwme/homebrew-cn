class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.18.0.tgz"
  sha256 "743bf8c50af072509a3f4d74a557adbf215f4b91ce6b6d59b6ad0564c9abe36b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa28b3a4bf1eedf491709ac86524639fbee870b7f2af7d415f49feb35526a39e"
    sha256 cellar: :any, arm64_sequoia: "fa28b3a4bf1eedf491709ac86524639fbee870b7f2af7d415f49feb35526a39e"
    sha256 cellar: :any, arm64_sonoma:  "fa28b3a4bf1eedf491709ac86524639fbee870b7f2af7d415f49feb35526a39e"
    sha256 cellar: :any, sonoma:        "e7a58d4067fba3436b3cff4abfbc90dd4d4081ad34c1c07e885692da5d593645"
    sha256 cellar: :any, arm64_linux:   "016feddb8ee9a7d7fc1609571adaed6774cd5c7f1d4ccad2c1f19e30a453a920"
    sha256 cellar: :any, x86_64_linux:  "ffa15005774dca1f6980e2daa48d2868d286523e81ab08538794acb330e524ab"
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