class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.208.tgz"
  sha256 "7252b003b1b40dd423460fd740263f499580c88289c93f21fcd0dabad5dca7b9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "93e314e420e63a582530bbe28ef3429eae31aad1ba4b4bed0a66c35ae6373ae0"
    sha256                               arm64_sequoia: "93e314e420e63a582530bbe28ef3429eae31aad1ba4b4bed0a66c35ae6373ae0"
    sha256                               arm64_sonoma:  "93e314e420e63a582530bbe28ef3429eae31aad1ba4b4bed0a66c35ae6373ae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "de50a504d29511225e337567746441b1548b1d135594f648711f26e47cc4e15f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e2116ed1750c7576534a528f9238a4fdb0ef8e95da15f106cd629f81f0e2d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56cbe5b59fe569dd54a968eb70c11b89688b5dd09828d4ea9f1a035bf02b325f"
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