class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.4.2.tgz"
  sha256 "a4b3ac63726ac9d2d69677067b34db98925e2226dde52e2a1457ad940100b34f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f4f7c8e7e770f39f8f5cd6fc2bb608e4ed53c33b79dd4c7bc057b84b9ae4e2a2"
    sha256 cellar: :any, arm64_sequoia: "4fb0f7cc1f707b77c561ceaa5d46de9bb4db434f25ed7798c6a03567ac154ce8"
    sha256 cellar: :any, arm64_sonoma:  "4fb0f7cc1f707b77c561ceaa5d46de9bb4db434f25ed7798c6a03567ac154ce8"
    sha256 cellar: :any, sonoma:        "4206946cddc0252c6c895a6790b4763f15b3923cd9365b6ec52b84005635b8bd"
    sha256 cellar: :any, arm64_linux:   "ab78a1d81481d88b555019cd20c68f2a460973a0218335b83fefa47acc63cbe5"
    sha256 cellar: :any, x86_64_linux:  "f9bf99c29f3e8d6f0697ac8edd1bc222a0a94414baf655fd36340e71a95091ac"
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