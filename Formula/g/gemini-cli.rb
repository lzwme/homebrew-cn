class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.44.0.tgz"
  sha256 "d5efa70cc25ee4bf06df3169621ab8f7bf83e57481e6018d837164123d4a3c89"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "501af1ef7acbb9f4d4849ab1d75f51a62938ba106b654f2f42a297d4147bb028"
    sha256                               arm64_sequoia: "dd5dd3aeb849366b4d891533fbb02aeb5f0c3b040a894e5f74cfdd0b085acb77"
    sha256                               arm64_sonoma:  "35de224fa972ace72ca829cf0ed0ab4abe840df6f47dff0ff7525ae90bf3487e"
    sha256                               sonoma:        "c99108db7f5dd027b2b38242e83375c0bcd0f742b46ace7169662283a81ba32e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20ea4c79b43e33416aee6799d2ca016324b05b60a8e0f1de61dc5ef22f32e9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4a079ee4e900db032e2dad0bba244915467518f402a73780cd814c93b6ef52"
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