class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.15.12.tgz"
  sha256 "ec862cd599874843b23aa37df9399e22179aa3b6fcad4125ef157475e5ff5308"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "d1e9177cb5fb69889cf0d0ea28b2732b8c359629fe7aa20bafe7861fde723188"
    sha256                               arm64_sequoia: "d1e9177cb5fb69889cf0d0ea28b2732b8c359629fe7aa20bafe7861fde723188"
    sha256                               arm64_sonoma:  "d1e9177cb5fb69889cf0d0ea28b2732b8c359629fe7aa20bafe7861fde723188"
    sha256 cellar: :any_skip_relocation, sonoma:        "34e9d915fac156dc47457749d1a00d7ee8f2518189379016b3060b38de2687ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf2532ecf3ae57c3b7dbdf65f3b1d5d1e17f8a69857ea09d3685a6ca3e0ae7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce0f28fc93f0a5a2f90d77214dffe0b429322b9ff8a78372a0ed7a5d90b89b9"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
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