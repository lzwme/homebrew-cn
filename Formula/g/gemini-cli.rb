class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.40.1.tgz"
  sha256 "893205127c072d3baa2fba419a28081b9fd5cb77c745883139dd9e3e2c1a2b2d"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "f2d25114b012c1a8814d246d2e05928b7fee18398c1219dc0dbb853572fe8d9b"
    sha256                               arm64_sequoia: "82985e242064d68e16493eb5660b157b02d06fc62dbd671dc3279af2d4a39e20"
    sha256                               arm64_sonoma:  "832fcf04bbd2c6e1610fa672529cfc8fd99ff7e021b2def1ae402a60de4ce000"
    sha256                               sonoma:        "0ca355f3773aa1b62d09aeea03e4c01f947a3c8480db6bd9f5f58c4d326e0beb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27448f2ff5d4d86651ac9fcc42fa3e21004db61f499342f5dfecd514ebdc753f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a56c4143ee20ef51ac5f515612b5bb305f23f574f05247047c2ba0375f3fabe"
  end

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