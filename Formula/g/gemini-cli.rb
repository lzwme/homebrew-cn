class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.27.0.tgz"
  sha256 "c136f01c2da01530eaf39b6b83f9117338a8f108c798e54d586d91ac1e808844"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05bc2bd77a05181b2abeed496d51b50d361a0c72007b054b5113dca2d1cece01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05bc2bd77a05181b2abeed496d51b50d361a0c72007b054b5113dca2d1cece01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05bc2bd77a05181b2abeed496d51b50d361a0c72007b054b5113dca2d1cece01"
    sha256 cellar: :any_skip_relocation, sonoma:        "f468b3c1114c10d2dbd442a645e7d89a258fb4020792f2f57b48032ba802b1ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "535a441af80f9a58dbf0020c48b9e388ad7b9c9f958e29148cb3ccc5f28b48e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d0ceb3e4c6ea5209901e037665a7e9b34f945b4d57dc7c20eb018ac0fa3e304"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    (node_modules/"tree-sitter-bash/prebuilds").glob("*")
                                               .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    (node_modules/"node-pty/prebuilds").glob("*")
                                       .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/@google/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end