class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://geminicli.com"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.65.0.tgz"
  sha256 "97f1f7f1e7e189054d27edfb9c62c6a45cec15b678840dfdde3c0ccd87fab376"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d6e674a2d5cb9bc2dab7568a9455b77ec4ca128795ee2b995aab33c9882a1ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "245224bdc8578d3c11e04df27a4d0cc95f63f6280022deda9614d9b47d933811"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0281c803ade5b537491ab08dca1bf4f6b3311a9ec447b565efdd614782b0091e"
    sha256 cellar: :any,                 arm64_linux:       "c6b5da13f1e913075c7f417e09c00d574072149377942d055ec301fa3677a457"
    sha256 cellar: :any,                 x86_64_linux:      "b5538af774a626e94a6b8b28e42b0b0f3073c944845445111e28678cf3ff717e"
  end

  deprecate! date: "2026-06-18", because: :unsupported, replacement_cask: "antigravity-cli"
  disable! date: "2026-12-18", because: :unsupported, replacement_cask: "antigravity-cli"

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
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