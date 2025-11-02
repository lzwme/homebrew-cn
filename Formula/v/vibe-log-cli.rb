class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.7.6.tgz"
  sha256 "e53b35ca24b0ad207a969e3af3b02fa4d2ac98517e8a01a021f20a5c0478988b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c0b14ba1dc371a6ecef295ca03c3f16cabc9f7ea0ee60691fb4dcab44f7f4844"
    sha256 cellar: :any,                 arm64_sequoia: "d094b70575adf732345dc5614e7034ae15f0bdecf750ad3b34169561d1b8ae60"
    sha256 cellar: :any,                 arm64_sonoma:  "d094b70575adf732345dc5614e7034ae15f0bdecf750ad3b34169561d1b8ae60"
    sha256 cellar: :any,                 sonoma:        "c26b230c27c63d330f982667036cc4354311d274daa25f26b05460ba0bfeda89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dbcfb956b6014317514306513ff4ce1fbb8425bc3ba0bcd479a0d7bd721a5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd48f8cace0b9fc94bf2e5ebe65acaf177c1313bb715d54e6960b2f255c2f3f7"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    vendor_dir = libexec/"lib/node_modules/vibe-log-cli/node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(vendor_dir)

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibe-log --version")
    assert_match "Failed to send sessions", shell_output("#{bin}/vibe-log send --silent 2>&1")
  end
end