class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.45.0.tgz"
  sha256 "c0565a62ea189cd28ee871cb0b1aea53d8ba7ac48168ffdd32c2b6271f5cd131"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "ecd36b3a872506b4cd78078e0367853fbcc0fc3695f83f6b27b6377ddba8c4ac"
    sha256               arm64_sequoia: "2d37bcfaf67a7142c62e451fe08a2ba733d70ad3d8fdb240231bb948e517ebb0"
    sha256               arm64_sonoma:  "ac05ac4fbb6bb7ae3abb40a41ab3ea77b4cdbee478ee2eb1c1fed8ad4ee394b4"
    sha256               sonoma:        "7368abc8ae8a4be06707feafea1499e6c47219ecb3e4bb92a9196d7e2f2b0acd"
    sha256 cellar: :any, arm64_linux:   "b26eaf875451068a0140bf0119bc88b0a9a125dd393d40efca2849c14ab379bd"
    sha256 cellar: :any, x86_64_linux:  "4704251735a1d38c05bec14abb4279054f4a655d03f314901ebdd0ff7667fa41"
  end

  deprecate! date: "2026-06-18", because: :unsupported, replacement_cask: "antigravity-cli"
  disable! date: "2026-12-18", because: :unsupported, replacement_cask: "antigravity-cli"

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url,tree-sitter-bash,node-pty}/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

    cd node_modules/"@github/keytar" do
      rm_r "prebuilds"
      system "npm", "run", "build"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end