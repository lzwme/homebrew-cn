class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.5.0.tgz"
  sha256 "015eb6f27ac19cfb1a8f8032fff95d2f0c48b845c836fffcddea2b5747a8ac9e"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0df06a1dd50a93bc6d1bd158ae91fd3820a3d5d6cbf7e08eb96da03943015fd"
    sha256 cellar: :any,                 arm64_sequoia: "ad6c0df5c6b2390a2e50e278ad758681b34360b1ddef7eb197e25aa43c7f1903"
    sha256 cellar: :any,                 arm64_sonoma:  "ad6c0df5c6b2390a2e50e278ad758681b34360b1ddef7eb197e25aa43c7f1903"
    sha256 cellar: :any,                 sonoma:        "3c52ba06437e659dfb99de887fcac41a620537a9b112d1d4f2510350afca4034"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06c2acb311d0506c1f8ee19bb8c68dcd7934d31a6778e003cef0c9b1867c5504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0120422a86daa0841eb4b7c28e3735519dc749c7734554eba9dd94f02dbaa3da"
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