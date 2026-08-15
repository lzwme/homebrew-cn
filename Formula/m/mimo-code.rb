class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.12.tgz"
  sha256 "7d1059f20fa3beeaadad19dd671c5326a7891cf26b34330d309d3f50a18b025b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0d11287b78803f53c62614e50b4f8c11540e586cf53515f1eb90bc6f1c7cbf0d"
    sha256                               arm64_sequoia: "0d11287b78803f53c62614e50b4f8c11540e586cf53515f1eb90bc6f1c7cbf0d"
    sha256                               arm64_sonoma:  "0d11287b78803f53c62614e50b4f8c11540e586cf53515f1eb90bc6f1c7cbf0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "05c2ecb2c9a8ee4b4104f11411072425a5644446288fd0d9c6037963c32d441f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0d953dfafd437f5965e624a932bc815513db8c0fca70c3fae131f65f0164663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01799795cea381d0251f4650fdb4e15839f945376a1fe2052f2389165659536a"
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