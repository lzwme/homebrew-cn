class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.6.5.tgz"
  sha256 "95efb5ed8a177068324c1ed83f891df446c936637096b89f32a496cc7e411540"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c10a868301eeffa188f0b2d091d80b80ba950fbc6beffd437212624fdc996869"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c10a868301eeffa188f0b2d091d80b80ba950fbc6beffd437212624fdc996869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c10a868301eeffa188f0b2d091d80b80ba950fbc6beffd437212624fdc996869"
    sha256 cellar: :any_skip_relocation, sonoma:        "f259b78f0eac8456a467da70270d4e7383b0064297f5128a49eb281708b6ce97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f8f2791e11ab98862595e24755d0156ea923821a1a96625b747bd8def4fd925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7881afa89b06de77e38309bfab19df8fa852671ae85dcd817766ef679733048"
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