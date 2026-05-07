class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.41.1.tgz"
  sha256 "6a57a9a027a90de880ac74ff78db13748175cc1e2c67be91c6178cfbee7cd595"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "680461dfbabbe7c66fe131da63a1e2566cbe39c9f19f09de3653e6bac30429dd"
    sha256                               arm64_sequoia: "828ee3dd376739c864a7e29e9587cf5a45937b56fc1537bc0c65f8007d25ade9"
    sha256                               arm64_sonoma:  "fa75e323038b0ed53490a66a0e8742787118167a63a63428b5864a5ef3af930f"
    sha256                               sonoma:        "442087d2d1a1fe16a7572d862df07e994f526471a0c9d9d5173f2b999f056133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f169ab8fdce08874ccf26113814032590683d8f1702437474304c30054c78e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "825c3bc9e94bda9c9a7a15970dfd871ce0293bc4243914ccf927b97c3e358922"
  end

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url,tree-sitter-bash,node-pty}/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

    cd node_modules/"@github/keytar" do
      rm_r "prebuilds"
      system "npm", "run", "build"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end