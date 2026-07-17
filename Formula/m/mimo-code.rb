class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.6.tgz"
  sha256 "8198b50c22dd821546567a85d6d2b8bd199cab7ea6e7443f75a5310b667b78f6"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0e769798fd392e41c1ae0beb74ef9e50459af192887b45ccf34cb60a4fdc9a89"
    sha256                               arm64_sequoia: "0e769798fd392e41c1ae0beb74ef9e50459af192887b45ccf34cb60a4fdc9a89"
    sha256                               arm64_sonoma:  "0e769798fd392e41c1ae0beb74ef9e50459af192887b45ccf34cb60a4fdc9a89"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a552601c1f121079b9c6ae87f7a3bae115741945e9eae90c3b9d8953e6e8ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "868700618a657d40337359f27080a0b6b0291e6cc653ff5b2a0319398db3c3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe0111e9c4acdd1f7f89957e111873aafc3196b0d7d10c9d0ae3746f3cfe70f0"
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