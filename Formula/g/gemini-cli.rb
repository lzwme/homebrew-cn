class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.14.0.tgz"
  sha256 "366027d2c6fd5afaf2a7ac08a00b7b73fe3eedef10210c1576896c4cde8dadcd"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "62559009b5f6ffe77ab4f80b168b07d8e5d1f17db8510336c086589beea29c60"
    sha256                               arm64_sequoia: "3a0a5da36021e7c91967bcdda85d7bb51c06ed23f63c37352184c94051d54887"
    sha256                               arm64_sonoma:  "43a13d6770b8e7437ad21429376c65cd18f5e9f3684e4d12ce0ee7df20cdd148"
    sha256                               sonoma:        "23f2ca78ff55f2c682793d8a2b6dce376557c09a38985d814f6a9f4e10bb2419"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efa3626522d92b9c5f5df61c047853962ef3f5ea61de432a1ec3148cf4910e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45820b41d1636e612d14278d81af49df0b6ef8997e5356318287519670fe2c8a"
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