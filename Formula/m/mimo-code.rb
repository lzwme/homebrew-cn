class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.0.tgz"
  sha256 "52eaecfea6648fbf3ecd01dbb6b31018fe317db758a3c745528d54e17ad52065"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e9147d37d1fa11499b5d2762fe7f6a20dd30d2858c09bd703cdf05e9c9443aad"
    sha256                               arm64_sequoia: "e9147d37d1fa11499b5d2762fe7f6a20dd30d2858c09bd703cdf05e9c9443aad"
    sha256                               arm64_sonoma:  "e9147d37d1fa11499b5d2762fe7f6a20dd30d2858c09bd703cdf05e9c9443aad"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4b71bdbeea30489fe1db4839443d780d738a5b282fdbd3d15404e582b35c786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d491ad6b1e7b3903b8e976f591a946df136fedc70520eb7783ebed855cd52b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a69b5a5ce4d6c5bf595fb66c9987d468ec6b67870c982b7dd9d7d7050e3f3338"
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