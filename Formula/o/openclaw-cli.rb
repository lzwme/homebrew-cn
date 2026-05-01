class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.27.tgz"
  sha256 "a45fb32d94caa1cf52a48a9a71701b63f58ca8f375094031000bfabe01231c0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb69d4d2b21aeab710e2a735676b0efdc156520e61736349edaedfd9d82d877c"
    sha256 cellar: :any,                 arm64_sequoia: "73e2c98cdaab659a8fe0262fae77cb4f2de21677435bf582b701a9fea1829639"
    sha256 cellar: :any,                 arm64_sonoma:  "73e2c98cdaab659a8fe0262fae77cb4f2de21677435bf582b701a9fea1829639"
    sha256 cellar: :any,                 sonoma:        "7bd23f4d88958bae7288a6ceea0e8deebbbc52235759db3ce2ec2cd0a223538e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd75f3b09542991e1531e37b891a567175e02b538319f3cf00581edeaa20ff11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e06a1fbb23eb55451d82d73bc31f253eae8c910fc35444bd80f569a801760bd6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # sqlite-vec falls back cleanly when the native extension is unavailable.
    # Remove macOS pre-built dylibs that fail Homebrew bottle linkage fixups.
    node_modules.glob("sqlite-vec-darwin-*").each { |dir| rm_r(dir) } if OS.mac?

    # The bundled Discord plugin ships unresolved nested dependencies and a
    # prebuilt macOS arm64 module that fails Homebrew linkage fixups.
    rm_r libexec/"lib/node_modules/openclaw/dist/extensions/discord"

    # Remove incompatible pre-built @node-llama-cpp binaries (non-native
    # architectures and GPU variants requiring CUDA/Vulkan)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    llama_target = "#{OS.linux? ? "linux" : "mac"}-#{arch}"
    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?(llama_target) &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end

    koffi_target = "#{OS.kernel_name.downcase}_#{arch}"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != koffi_target
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end