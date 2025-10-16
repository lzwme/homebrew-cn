class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.9.0.tgz"
  sha256 "75a632e7501a7450a2784eaef9afb22bb0d3e1960a38cd61a33fdb56f9c44399"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "6c00bc0318ad9bbc3b62a8ac9b7674e9a2cbf9f2eac170221022aec6788f846c"
    sha256                               arm64_sequoia: "e8044bd952cd2960835f104d09a0dd46e45439f8b0b479bfce2a6758f902a22b"
    sha256                               arm64_sonoma:  "a78b01fcf53e34cc7109bd01a0693b6bd83ad1f188bb6ad8ed747a4f656cbf23"
    sha256                               sonoma:        "d881dfd50458d6ff6987172bdafe4bd7bc6816809d0ace728e7a53775bfd698b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10e55723bafb53e428ecd0d0517f561dfa55e7778945c92bb7a17145ca172b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9e18074a5ae194036f19d1a76413780eb05eaca9bbe41ea7f353252571b6943"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end