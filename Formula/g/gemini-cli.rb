class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.43.0.tgz"
  sha256 "65488d68d19bd6b2bfb623cd64a2a1f2ad1c5301722613d1449b9576e9d24fa5"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "29dadbf554861192c670b8d6e9e8b2a93ff91b63f3d372595aa718295948e47a"
    sha256                               arm64_sequoia: "c73b1c763d0cd4e4aba10eb5a9ae7fabfa035b495d97585767797ba7442bc9d2"
    sha256                               arm64_sonoma:  "36ba8a72ed1b26f2b7fb070da27668c957039e796ce2a66ef4c4d89d812dd0f6"
    sha256                               sonoma:        "03a36463964ae109e7a5467add25dbc34def3ee397ed50b362aade1590c3ce3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b4928857ad7a3bc0e365112f0c0bd9c001ca6b53d78e6082eae39cb54d6c6c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f24c9cc13ab892508fc2aefdecb0781ce422df2bb3ae7feae94e3774363d7ddc"
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