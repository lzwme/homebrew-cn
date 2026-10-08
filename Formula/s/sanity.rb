class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.14.0.tgz"
  sha256 "75ef34e966c08a138bc27d43234fbc2f384547053d0db6b100de798c5c4adce8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "491891f6793311e563f4704079f0f8b603640e5285268fc907f00f09c7867e3f"
    sha256 cellar: :any, arm64_tahoe:       "491891f6793311e563f4704079f0f8b603640e5285268fc907f00f09c7867e3f"
    sha256 cellar: :any, arm64_sequoia:     "491891f6793311e563f4704079f0f8b603640e5285268fc907f00f09c7867e3f"
    sha256 cellar: :any, arm64_linux:       "7d482e1bec933146f610d2f254388558e2bb6df47bb4f453ff81894f14c61c7e"
    sha256 cellar: :any, x86_64_linux:      "234c782aa476ab1377c15511049f09fc740170f8c54ce58321d6a792da946ce5"
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