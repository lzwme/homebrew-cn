class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.10.tgz"
  sha256 "d40b21336076969b57d5c420dc896ba81f073467684aa03fb59f4a9e9f4ecef5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2034696da2540f72c388307b80bbdc57f15db9b1046838fa10442730202a5528"
    sha256 cellar: :any,                 arm64_sequoia: "3b8c9018fa3426f595e0a631bcd10026407a87a1ea31e5c3c329a6b25a066dcc"
    sha256 cellar: :any,                 arm64_sonoma:  "3b8c9018fa3426f595e0a631bcd10026407a87a1ea31e5c3c329a6b25a066dcc"
    sha256 cellar: :any,                 sonoma:        "562d8f88ba34695a44bc1e0c25a23719357e9f5a22e6aae19ce961c90063ef65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb4191f908464389f16ce590013bbef20ca256124eecb793a1bf51729da56e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5676fd5f95496133bd191075ded8d36da97b687329d6e327cc7e511e59d8ac41"
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