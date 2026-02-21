class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.29.5.tgz"
  sha256 "baaac2889ece5514632537c99aa7cda558a6b469ad771e204f56db2b8cf6402a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00ee38647ed00959bbff13efd1fcd0e7b1ff0d60e1cf58d42df95977dd3f5844"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00ee38647ed00959bbff13efd1fcd0e7b1ff0d60e1cf58d42df95977dd3f5844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00ee38647ed00959bbff13efd1fcd0e7b1ff0d60e1cf58d42df95977dd3f5844"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a16b49628e4d2cf46bad4599f147319f8676cd68b12348666ec9fa1cd6a380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5effc538ffe96a4d2a41a1564655912009023fb0ec67d59dac34f506db90d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f04df65c4f20646a0085a0f50a34d15f692ef377feb5e8e7a95f017b28cc430e"
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