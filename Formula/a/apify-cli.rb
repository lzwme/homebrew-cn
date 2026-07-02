class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.6.3.tgz"
  sha256 "0f3073270d5d57304ebae546bbd18e1f85a2bfee4aee7bfa24b6767195dd8b8a"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7c076600abbf33adf15f9ac4b0e16e85096110d0ac097e1ef8e5e65bdc9aafc3"
    sha256 cellar: :any, arm64_sequoia: "577ec23ce47281bef597695871f689671cb3b0ad8582b66b4c7449055078cb4d"
    sha256 cellar: :any, arm64_sonoma:  "577ec23ce47281bef597695871f689671cb3b0ad8582b66b4c7449055078cb4d"
    sha256 cellar: :any, sonoma:        "b0ebc3ea324b8e926bf21fe1acbd790fddc19d0b4f2ff4c936357fe6659ccf38"
    sha256 cellar: :any, arm64_linux:   "07ad8e770d5fb6741737a1dfe808790f14a1f87c5ab7620658987c65ba814073"
    sha256 cellar: :any, x86_64_linux:  "10d7eeae4fb6e190c60feed7e3b86f052df3177f75f8d14a101ce241d7ccf2d8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/apify-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end