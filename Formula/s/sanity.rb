class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-6.7.2.tgz"
  sha256 "4b5b6afb12bf19936e3a10a3a7ad5f2de41425b3228dd6bd9742cf98fb9d2e3a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5839215f3f470a72152f48ab027e78b4fbea81d003cec7ce8ac92831d6d9545e"
    sha256 cellar: :any, arm64_sequoia: "7de3190495ecb002eb25795547552b5e1daf3c475ac7f8ffc3b61a69b1e2ad9f"
    sha256 cellar: :any, arm64_sonoma:  "7de3190495ecb002eb25795547552b5e1daf3c475ac7f8ffc3b61a69b1e2ad9f"
    sha256 cellar: :any, sonoma:        "bf4a3b50c7713a0288bfa1943ad1d0a648e5a9fd6f5e7bb45af1fcae33b022f9"
    sha256 cellar: :any, arm64_linux:   "0065b8751040f5a11975bb37c7f05b1c8ddd36e378b956e5e4ff75b7dcbd5b30"
    sha256 cellar: :any, x86_64_linux:  "1c97702cedcdb1775600f6a9d2236d3c5eb78cafaad05efd4b5ce6dc95e60eb5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
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