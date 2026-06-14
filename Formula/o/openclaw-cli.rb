class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.6.6.tgz"
  sha256 "dc869bb0486abd9b5e215caaba8c1bea0fb4507660b1dcf9b287e36b1f60bdbb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f97019475491a2e6d327a09af56cefd8555f0f9f53ff6434cc1e15dfc085616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f97019475491a2e6d327a09af56cefd8555f0f9f53ff6434cc1e15dfc085616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f97019475491a2e6d327a09af56cefd8555f0f9f53ff6434cc1e15dfc085616"
    sha256 cellar: :any_skip_relocation, sonoma:        "acb81075141810afcdb0c3147f30a48d6e31edce2c8b3b6032c9e7cb82f3b134"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe17a312c1930896985fd6cbc8d204e3861134d3bf9e066d0f9692f6bab87995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f839ba25d2155b125e992b87095932d7d5e7ac5f7929210127d62ad8996feae"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"

    # sqlite-vec falls back cleanly when the native extension is unavailable.
    # Remove macOS pre-built dylibs that fail Homebrew bottle linkage fixups.
    node_modules.glob("sqlite-vec-darwin-*").each { |dir| rm_r(dir) } if OS.mac?

    # Remove incompatible pre-built binaries (non-native architectures
    # and GPU variants requiring CUDA/Vulkan)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    target = "#{OS.linux? ? "linux" : "mac"}-#{arch}"

    node_modules.glob("tree-sitter-bash/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != target
    end

    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?(target) &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end

    os = OS.kernel_name.downcase
    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end

    node_modules.glob("koffi/build/koffi/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end