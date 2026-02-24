class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.29.6.tgz"
  sha256 "f644d4426fd89244fb5eca4ca7219ed3682cb7e9ff5297fea5b05af233ae40df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "713555e64e1b090187441051791ad876c7bb1d5696b4e7ca1cbcc8f7e6d0bde6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "713555e64e1b090187441051791ad876c7bb1d5696b4e7ca1cbcc8f7e6d0bde6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "713555e64e1b090187441051791ad876c7bb1d5696b4e7ca1cbcc8f7e6d0bde6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a469d2b918e21b9b24bb390d3d4327273e45fcba61f64266d90132974d83bf44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c16c0d79008b123e091f01f0b85917bc44f991152119bdc2e8bfa30d6f58490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "397e81c3b8e150911e3ae336d6a5c4ced7af79aa037dd43d57c0e94cae5959e8"
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
    (node_modules/"tree-sitter-bash/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

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