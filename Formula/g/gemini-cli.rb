class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.45.1.tgz"
  sha256 "a66d92d886cc51f4b920cc30f40f2cd7968f028d87770ec000c0d263f5799b52"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "6a0e670a651baaa34080995f579b1b61ee14ea94cd8495bbf3c78f20b57bd65c"
    sha256               arm64_sequoia: "922156f8f9453822eeff7501fc0deb6e434db04f0e7a5b6ae5a65dcfdd1160c9"
    sha256               arm64_sonoma:  "50f85195b85d2345634c7c342231e9e96eda28eb58d9494efbc9dde15b46fcb6"
    sha256               sonoma:        "5c35ae746e7d444c097b68749090943b48f5bd4538409f73114d5e16a3764c3a"
    sha256 cellar: :any, arm64_linux:   "f4a1ce850aa698b3f7a1f821afd2415f036f873b6d732ef636ff8f98da9efbb6"
    sha256 cellar: :any, x86_64_linux:  "9fabea495d52896da40245011233c5bf8a16c4e9fe00780abca54decb92d1c62"
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