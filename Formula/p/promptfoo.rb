class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.24.tgz"
  sha256 "8c850c1071a7f1e4ee5d62f8d685756e6467cf6d70a31a7111ac990e4e54951f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "78a50317e86c525a2967118519357810c282c02ea08687136a1415ddedbc3ba9"
    sha256                               arm64_sequoia: "81f8760604d5e7048b18eecfc1757a501c181f7f75a8c5f94cb39794b5add157"
    sha256                               arm64_sonoma:  "0a358c1ad1f53eb21a9b78fc99f54faea6fc0e709b7e36bf676aa088a4451c86"
    sha256                               sonoma:        "fe09f7479d9a1e896c47ec0445b777d38d99f8992410e1c7faf50bbb2224a29a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f44ec1354096a1af9f3f10e6bf544956a4dfa06adb69c8b6b3802de9078a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31a4a51eeff117c6ba64e827f5c84d25e05ab42c63f1399466f07c3cd1f3e46c"
  end

  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
    depends_on "gettext"
  end

  fails_with :clang do
    build 1699
    cause "better-sqlite3 fails to build"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz"
    sha256 "d12f07c8162283b6213551855f1da8dac162331374629830b5e640f130f07910"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    os = OS.mac? ? "apple-darwin" : "unknown-linux-musl"
    arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    rm_r(node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep")
    codex_vendor = node_modules/"@openai/codex-sdk/vendor"
    codex_vendor.children.each { |dir| rm_r dir if dir.basename.to_s != "#{arch}-#{os}" }

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    keep = node_modules.glob("onnxruntime-node/bin/napi-v*/#{OS.kernel_name.downcase}/#{arch}")
    rm_r(node_modules.glob("onnxruntime-node/bin/napi-v*/*/*") - keep)
    if OS.linux? && Hardware::CPU.intel?
      rm(node_modules.glob("onnxruntime-node/bin/napi-v*/*/*/libonnxruntime_providers_{cuda,tensorrt}.so"))
    end

    # Remove unneeded pre-built binaries
    rm_r(node_modules.glob("@img/sharp-*"))
    rm_r(node_modules.glob("sharp/node_modules/@img/sharp-*"))
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end