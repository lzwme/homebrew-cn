class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.6.9.tgz"
  sha256 "581c61d9cfef2dd0235508fef68293d07b8f56e3f22728633c2c5229a3322596"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "191c91f11177ef55734848d227f0b8bba7e666c25ac152156b701e3846ca08aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "191c91f11177ef55734848d227f0b8bba7e666c25ac152156b701e3846ca08aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "191c91f11177ef55734848d227f0b8bba7e666c25ac152156b701e3846ca08aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "57bfc197141a7c5f7825aa7954486100e3732bf099a352e899bb0b7c85ca9361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50d31ee3d43c10f8bc8d9f625e6620f34ace816e50232f5861509a5666b0b629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06b77e09147148f415010a884c8bb04536d2d132d3448976246349c0f76b318a"
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