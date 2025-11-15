class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.15.1.tgz"
  sha256 "3f12613c07219c0d6ec745a3fca448228dfb994d49ace3d8e3ae54a7bbfe2841"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "d8198e9186ea3e6327047974beff26025aa5d2185a9591fb54e19b7d12c53cf2"
    sha256                               arm64_sequoia: "81c0ff563912c9d44a7ce9dbf6bf26aa5bb2e5fd74b28a85896d80199c453a04"
    sha256                               arm64_sonoma:  "bd0ac1f6b2a1b8e2e0657fe46bc4a2d5198b7720206a7273c7857103cac29c76"
    sha256                               sonoma:        "9b279986f8e83f9ba5698429f8fdbce03c78901f596a1b44731e7d2db8d54acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba86dc9692cb49d555bc3c7f8944b3438d2857fe2dcecbb216ae68e0d406573a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ad70ee80a2251cbb0bde58c9a4a582eaed27c1166f5401d1ec1ef61f871fe2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    libexec.glob("#{node_modules}/tree-sitter-bash/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end