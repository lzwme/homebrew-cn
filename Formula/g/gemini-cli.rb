class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.44.1.tgz"
  sha256 "fcf5dc9f01eb602e64c204f7112bf33e17ba5e36f737a8ed374821c838ab2cf9"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "9e459d270bb4ccb8814f2e7782ddc3167a3b785f7b5fcfdc11903070c58fcded"
    sha256               arm64_sequoia: "90229e6460cf9252d5293370fbc80373bbfefad33f9e1fb89ccb8cc36067462f"
    sha256               arm64_sonoma:  "c2ca0f7267ea9c959e0ee8de699df24f0bf5f9755558850cdd1e8b28f6b5dc8b"
    sha256               sonoma:        "84424930e4d0e10b9b7a99820d2014b65f29091caedb274bf33eeb37164feb60"
    sha256 cellar: :any, arm64_linux:   "278baf8078ec60ac0c367d951bd99d71cfbc13cfb9ef79ae00c34edddb6ede68"
    sha256 cellar: :any, x86_64_linux:  "dbb9f06308b79e43976d6d5352cdf984ee458a49ad8a0d4d7a5da8e1b0e4c875"
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