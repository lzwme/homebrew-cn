class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.72.0.tgz"
  sha256 "87c4cc82fc72b44d59e9fd323f10f9de47a542967257cca6d1843ae5605e3804"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7bec76e57172b9d48c040be3f4175378db9c398425e6d1dc65069c82e289fba0"
    sha256 cellar: :any,                 arm64_sequoia: "a099f50fecc4462d9ae6ec800c4410357c0c0b5caa15f9849ccd43e7b58af48e"
    sha256 cellar: :any,                 arm64_sonoma:  "a099f50fecc4462d9ae6ec800c4410357c0c0b5caa15f9849ccd43e7b58af48e"
    sha256 cellar: :any,                 sonoma:        "fc9a1463d332f4713d657b39f311701ba2aa5bd148bd9c704ba9bd3f17f64ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b5284a6f34ec42346cd311a9116e464a3d09f675ed75da8be2d38d3fe54298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11af261f03fd3b60f3a91ca1d71a068ffd1efbe19708e2d16c5db3b9bbe52964"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end