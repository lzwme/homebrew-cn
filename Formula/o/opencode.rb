class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.201.tgz"
  sha256 "19f712e2a5e0a4be65c380529f29e2402d1117ad0b270c53a03a51f69de10dd9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ff85d18a3392af89e88c353016086413fbee29e34c2dd96c46a7daf683bb4c18"
    sha256                               arm64_sequoia: "ff85d18a3392af89e88c353016086413fbee29e34c2dd96c46a7daf683bb4c18"
    sha256                               arm64_sonoma:  "ff85d18a3392af89e88c353016086413fbee29e34c2dd96c46a7daf683bb4c18"
    sha256 cellar: :any_skip_relocation, sonoma:        "561e91c0f7ac12fb09fc3360f34032963dac360e90a275f2c0378d8c23e76718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7c1e4b295528dad3a2fbd5a6377cd3f88dcb37e5ebc291085c9fe62b0563024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f7200681a40125886bb54bab8b89e19f682ee177ae2d61f365208c0930181c"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end