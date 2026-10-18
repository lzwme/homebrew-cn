class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.18.0.tgz"
  sha256 "865add5de499afcccea9453b170fa89ee37dd793566c92581cefcec6bca1379e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0af4a44b4e5b97cbb56e3537e99e438546e89457f4adac1709e7a0c54b9df433"
    sha256 cellar: :any, arm64_tahoe:       "0af4a44b4e5b97cbb56e3537e99e438546e89457f4adac1709e7a0c54b9df433"
    sha256 cellar: :any, arm64_sequoia:     "0af4a44b4e5b97cbb56e3537e99e438546e89457f4adac1709e7a0c54b9df433"
    sha256 cellar: :any, arm64_linux:       "3d34052ae0fb908432cde9f0f60b3e4072a322b80c47b25d1fd03fe847fd4146"
    sha256 cellar: :any, x86_64_linux:      "514a19a5f1df116e389310b071b218e1b8e327eed0c1dc26f144e8efb7014aba"
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