class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.15.3.tgz"
  sha256 "d80b73972ff7ce70c4d4c630a4223a6b2557a5169881cdddc63f3a9f959fae87"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "464d83e81c6420b0e813a34111e6f4c0ac9d69dd198eaebc6ee3f611a67f0b96"
    sha256                               arm64_sequoia: "0a1b24e5d89fd856afd65625b966d8c52de76fa8fa25e45a5c7ef860ada0757b"
    sha256                               arm64_sonoma:  "8143a3ebcdb933e1aadeb7291f16f79c2f2a0ed23622851972a0c80681272799"
    sha256                               sonoma:        "28f381d0c03ac774471b1210da07285780a3ecb8dba83e5ce3f25bbd9fd7bbd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7748b43bf198a387f7e300e1e138a626bc034f815b0404b7758e96aca29b5e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8abec8c756b4954bb392dd45e04b7bf5ef28b19b2b1c7c356380be280ecd5f2c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    libexec.glob("#{node_modules}/tree-sitter-bash/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end