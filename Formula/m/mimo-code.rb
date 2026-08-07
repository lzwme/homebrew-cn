class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.10.tgz"
  sha256 "a93149c1fd67e4b0997fe276c74c472b1eee330dfd4e5cb5d4249bc8f4dec0bf"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ca9637bd09aa43adb3248477b4150e3b1afae02e0f12e8ba7bdb63fa6db9af43"
    sha256                               arm64_sequoia: "ca9637bd09aa43adb3248477b4150e3b1afae02e0f12e8ba7bdb63fa6db9af43"
    sha256                               arm64_sonoma:  "ca9637bd09aa43adb3248477b4150e3b1afae02e0f12e8ba7bdb63fa6db9af43"
    sha256 cellar: :any_skip_relocation, sonoma:        "25de2630e8208e1f8df2bbff3a73268e1f7674caf68fd0ccc699786d42a65b58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b72e4ca2ed109fd5565596f00b0d0a919c659b6f9c2ecb249902497d80c85cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7171293d26362b2720a469c39d235a0bcd8a0170a54c3c6b6e5502b0d3052c0a"
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