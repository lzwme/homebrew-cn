class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.1.50.tgz"
  sha256 "5245c67c1e2a5fbab5dc09a6f9567f75978c089a9c3240794002c276b4743d13"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "887457a9d364eddfff337605017545bfd7186efb59912b0aafc7a217c1efe7d0"
    sha256                               arm64_sequoia: "887457a9d364eddfff337605017545bfd7186efb59912b0aafc7a217c1efe7d0"
    sha256                               arm64_sonoma:  "887457a9d364eddfff337605017545bfd7186efb59912b0aafc7a217c1efe7d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "da8c1f8f3eae33f1d408a676cf6be4cf50da292fe7f286b952b6b805b4832bcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b463b54b41ea03781996809e2b8fdf1ae2682f09e8fdcb6daf48ae30806ddb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "279bb417b51bda4625a9cda30cde3181a218c5b08b4761ed766524966c5989ab"
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