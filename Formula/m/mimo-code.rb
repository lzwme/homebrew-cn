class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.8.tgz"
  sha256 "369711b09e9df22dbb55bbcb2b1e15e6b3c52ab0c270d1a787ec63f5290c5142"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "01bedea3f4e76bf95e4628b22b411b80d77bf4d6648977d1ace18f9d14a66b79"
    sha256                               arm64_sequoia: "01bedea3f4e76bf95e4628b22b411b80d77bf4d6648977d1ace18f9d14a66b79"
    sha256                               arm64_sonoma:  "01bedea3f4e76bf95e4628b22b411b80d77bf4d6648977d1ace18f9d14a66b79"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b9378b497e1520cdb7555f323ee0eaca9b9eff61b19e4b94b54754ddd0e986d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ec5a1e32a9a2cfefb6cbe073fbccc1030066124a1ccc4cd65c0b08067f832de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbe340b57ba87b2e4ddb88b8679887360ce03fdf80bb73480e025503fdd204a6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/@mimo-ai/cli/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "mimocode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mimo --version")
    assert_match "mimo", shell_output("#{bin}/mimo models")
  end
end