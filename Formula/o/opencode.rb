class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.1.60.tgz"
  sha256 "c1f2a775596ac92a93de7f0f9242fb0d691253fe788735daa60a0b75ee040c1f"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "fb832ea4045bbd5ea648ee98fc8f969f4e924aa79e60f1ef4434fa3eb3678fe8"
    sha256                               arm64_sequoia: "fb832ea4045bbd5ea648ee98fc8f969f4e924aa79e60f1ef4434fa3eb3678fe8"
    sha256                               arm64_sonoma:  "fb832ea4045bbd5ea648ee98fc8f969f4e924aa79e60f1ef4434fa3eb3678fe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "92cd4fda434bc51b5c93534cd26d1bc92b3e9d54e2e418e046f5f6dde69bb39e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a96cb69f19a58f77c46acee40b958a38764222d15565f236f79946cf6b78cf94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8c3fcdb4fa7e13765a7e8b45613d320ecc552bdae551752d6156b5ca05067dd"
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