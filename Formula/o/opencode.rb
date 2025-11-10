class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.51.tgz"
  sha256 "41c974ddc2d8db14a1c3d1f634b6c65656db317e71cd03770f00ed79397939bd"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9eed2f40446f599d33e931ee25e3343af4c5cedd7f0b7c31049f8b69815ecb9e"
    sha256                               arm64_sequoia: "9eed2f40446f599d33e931ee25e3343af4c5cedd7f0b7c31049f8b69815ecb9e"
    sha256                               arm64_sonoma:  "9eed2f40446f599d33e931ee25e3343af4c5cedd7f0b7c31049f8b69815ecb9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cec6b0fbba3e1b65478109d7f35b1a06124f4bde3a585fdddf013a3ea2d6049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b1c9336d377449459195d64d5057819cb47dd0bca4103cda12ad51bd42d2648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2adf36ef1cc50fad7fe9e16356dad5758333415fa9ae7336adc96b9d996b073a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end